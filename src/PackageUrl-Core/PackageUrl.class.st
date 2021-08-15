Class {
	#name : #PackageUrl,
	#superclass : #Object,
	#instVars : [
		'type',
		'namespace',
		'name',
		'version',
		'qualifiers',
		'subpath'
	],
	#category : #'PackageUrl-Core'
}

{ #category : #'instance creation' }
PackageUrl class >> dockerName: imageName [

		^ self
		  type: 'docker'
		  namespace: nil
		  name: imageName
		  version: nil
		  qualifiers: nil
		  subpath: nil
]

{ #category : #'instance creation' }
PackageUrl class >> dockerName: imageName version: version [

	^ self
		  type: 'docker'
		  namespace: nil
		  name: imageName
		  version: version
		  qualifiers: nil
		  subpath: nil
]

{ #category : #'instance creation' }
PackageUrl class >> dockerRepository: repository name: imageName version: version [

	^ self
		  type: 'docker'
		  namespace: repository
		  name: imageName
		  version: version
		  qualifiers: nil
		  subpath: nil
]

{ #category : #'instance creation' }
PackageUrl class >> fromString: aString [

	"Implementation according to https://github.com/package-url/purl-spec/blob/master/PURL-SPECIFICATION.rst#user-content-how-to-parse-a-purl-string-in-its-components "

	| remainder subpath qualifiers scheme type version aName namespace |
	"Split the purl string once from right on '#'
	The left side is the remainder"
	$#
		splitRight: aString
		leftDo: [ :value | remainder := value ]
		rightDo: [ :value | 
			subpath := value
				           ifEmpty: [ nil ]
				           ifNotEmpty: [ self parseSubpath: value ] ].

	"Split the remainder once from right on '?'
   The left side is the remainder
	The right side is the qualifiers string"
	$?
		splitRight: remainder
		leftDo: [ :value | remainder := value ]
		rightDo: [ :value | 
			qualifiers := value
				              ifEmpty: [ nil ]
				              ifNotEmpty: [ self parseQualifiers: value ] ].

	"Split the remainder once from left on ':'
    The left side lowercased is the scheme
    The right side is the remainder"
	$:
		splitLeft: remainder
		leftDo: [ :value | 
			scheme := value ifEmpty: [ nil ] ifNotEmpty: [ value asLowercase ] ]
		rightDo: [ :value | remainder := value ].

	"Strip the remainder from leading and trailing '/'"
	remainder := remainder trimSlashes.

	"Split this once from left on '/'
	The left side lowercased is the type
	The right side is the remainder"
	$/
		splitLeft: remainder
		leftDo: [ :value | 
			type := value ifEmpty: [ nil ] ifNotEmpty: [ value asLowercase ] ]
		rightDo: [ :value | remainder := value ].

	"Split the remainder once from right on '@'
	The left side is the remainder
	Percent-decode the right side. This is the version.
	UTF-8-decode the version if needed in your programming language"
	$@
		splitRight: remainder
		leftDo: [ :value | remainder := value ]
		rightDo: [ :value | 
			version := value ifEmpty: [ nil ] ifNotEmpty: [ value packageUrlDecoded ] ].

	"Split the remainder once from right on '/'
    The left side is the remainder
    Percent-decode the right side. This is the name
    UTF-8-decode this name if needed in your programming language
    Apply type-specific normalization to the name if needed"
	remainder := $/ split: remainder.
	aName := remainder removeLast ifEmpty: [ 
		         PackageUrlError signal: 'a name is required' ].


	"Split the remainder on '/'
    Discard any empty segment from that split
    Percent-decode each segment
    UTF-8-decode the each segment if needed in your programming language
    Apply type-specific normalization to each segment if needed
    Join segments back with a '/'
    This is the namespace"

	namespace := ($/ join:
		              ((remainder reject: #isEmpty) collect: #packageUrlDecoded)) 
		             ifEmpty: [ nil ].

	^ self
		  type: type
		  namespace: namespace
		  name: aName
		  version: version
		  qualifiers: qualifiers
		  subpath: subpath
]

{ #category : #accessing }
PackageUrl class >> neoJsonMapping: mapper [

	mapper for: self customDo: [ :mapping | 
		mapping
			decoder: [ :string | self fromString: string ];
			encoder: [ :mimeType | self halt ] ]
]

{ #category : #private }
PackageUrl class >> parseQualifiers: aString [

	| qualifiers pairs |
	qualifiers := Dictionary new.
	"Split the qualifiers on '&'. Each part is a key=value pair"
	pairs := $& split: aString.
	pairs do: [ :pair | 
		| split key value |
		"For each pair, split the key=value once from left on '=':"
		split := $= split: pair.
		"value cannot be an empty string: a key=value pair with an empty value is the same as no key/value at all for this key"
		split size = 2 ifTrue: [
		"The key is the lowercase left side"
		key := split first asLowercase.
		key
			detect: [ :each | each isAllowedInPackageUrlKey not ]
			ifFound: [ :char | 
				PackageUrlError signal:
					'The key must be composed only of ASCII letters and numbers, ''.'', ''-'' and ''_'' (period, dash and underscore)' ].
		key first isDigit ifTrue: [ 
			PackageUrlError signal: 'A key cannot start with a number' ].
		key packageUrlDecoded = key ifFalse: [ 
			PackageUrlError signal: 'A key must NOT be percent-encoded' ].
		"The value is the percent-decoded right side"
		value := split second packageUrlDecoded.
		"UTF-8-decode the value if needed in your programming language"
		"Discard any key/value pairs where the value is empty"
		(key isEmpty or: [ value isEmpty ]) ifFalse: [ 
			qualifiers at: key put: (false
					 ifTrue: [ "key = 'checksums'" "If the key is checksums, split the value on ',' to create a list of checksums" 
						 $, split: value ]
					 ifFalse: [ value ]) ] ]].
	"This list of key/value is the qualifiers object"
	^ qualifiers
]

{ #category : #private }
PackageUrl class >> parseSubpath: aString [

	| subpath |
	"Strip the right side from leading and trailing '/'"
	subpath := aString trimSlashes.
	"Split this on '/'"
	subpath := $/ split: subpath.
	"Discard any empty string segment from that split
	Discard any '.' or '..' segment from that split"
	subpath := subpath reject: [ :each | 
		           each isEmpty or: [ each = '.' or: [ each = '..' ] ] ].
	"Percent-decode each segment"
	subpath := subpath do: #packageUrlDecoded.
	"UTF-8-decode each segment if needed in your programming language"
	"Join segments back with a '/'
	This is the subpath"
	^ $/ join: subpath
]

{ #category : #accessing }
PackageUrl class >> systemIconName [ 
^#package
]

{ #category : #'instance creation' }
PackageUrl class >> type: aType namespace: aNamespace name: aName version: aVersion qualifiers: aDictionary subpath: aSubpath [

	^ self new
		  setType: aType
		  namespace: aNamespace
		  name: aName
		  version: aVersion
		  qualifiers: aDictionary
		  subpath: aSubpath;
		  sanitize;
		  yourself
]

{ #category : #comparing }
PackageUrl >> = aPackageUrl [
^self class = aPackageUrl class ifTrue: [ self canonical  = aPackageUrl canonical  ]
]

{ #category : #accessing }
PackageUrl >> canonical [

	^ String streamContents: [ :stream | self printCanonicalOn: stream ]
]

{ #category : #converting }
PackageUrl >> dockerIdentifier [

	^ String streamContents: [ :stream | 
		  namespace ifNotNil: [ :value | stream nextPutAll: value ; nextPut: $/].
		  stream nextPutAll: name.
		  version ifNotNil: [ :value | 
			  stream
				  nextPut: $:;
				  nextPutAll: value ] ]
]

{ #category : #comparing }
PackageUrl >> hash [

	^ self canonical hash
]

{ #category : #accessing }
PackageUrl >> name [
	^ name
]

{ #category : #accessing }
PackageUrl >> namespace [
	^ namespace
]

{ #category : #printing }
PackageUrl >> printCanonicalOn: aStream [

	"Start a purl string with the 'pkg:' scheme as a lowercase ASCII string
	Append the type string to the purl as a lowercase ASCII string
	Append '/' to the purl"

	aStream
		nextPutAll: 'pkg:';
		nextPutAll: type;
		nextPut: $/.

	namespace
		ifNotNil: [ "If the namespace is not empty:
        Strip the namespace from leading and trailing '/'
        Split on '/' as segments
        Apply type-specific normalization to each segment if needed
        UTF-8-encode each segment if needed in your programming language
        Percent-encode each segment
        Join the segments with '/'
        Append this to the purl
        Append '/' to the purl
        Strip the name from leading and trailing '/'
        Apply type-specific normalization to the name if needed
        UTF-8-encode the name if needed in your programming language
        Append the percent-encoded name to the purl"
			aStream
				nextPutAll:
					($/ join: (($/ split: namespace) collect: #urlEncoded));
				nextPut: $/;
				nextPutAll: name urlEncoded ]
		ifNil: [ "If the namespace is empty:
        Apply type-specific normalization to the name if needed
        UTF-8-encode the name if needed in your programming language
        Append the percent-encoded name to the purl" 
			aStream nextPutAll: name urlEncoded ].

	version ifNotNil: [ "If the version is not empty:
        Append '@' to the purl
        UTF-8-encode the version if needed in your programming language
        Append the percent-encoded version to the purl"
		aStream
			nextPut: $@;
			nextPutAll: version packageUrlEncoded ].

	qualifiers isEmptyOrNil ifFalse: [ "If the qualifiers are not empty and not composed only of key/value pairs where the value is empty:
        Append '?' to the purl
        Build a list from all key/value pair:
            discard any pair where the value is empty.
            UTF-8-encode each value if needed in your programming language
            If the key is checksums and this is a list of checksums join this list with a ',' to create this qualifier value
            create a string by joining the lowercased key, the equal '=' sign and the percent-encoded value to create a qualifier
        sort this list of qualifier strings lexicographically
        join this list of qualifier strings with a '&' ampersand
        Append this string to the purl"
		aStream nextPut: $?.
		qualifiers keys sorted
			do: [ :key | 
				| value |
				"key = 'checksums'"
				value := (false
					          ifFalse: [ qualifiers at: key ]
					          ifTrue: [ $, join: (qualifiers at: key) ]) packageUrlEncoded.
				aStream
					nextPutAll: key;
					nextPut: $=;
					nextPutAll: value ]
			separatedBy: [ aStream nextPut: $& ] ].

	subpath ifNotNil: [ "If the subpath is not empty and not composed only of empty, '.' and '..' segments:
        Append '#' to the purl
        Strip the subpath from leading and trailing '/'
        Split this on '/' as segments
        Discard empty, '.' and '..' segments
        Percent-encode each segment
        UTF-8-encode each segment if needed in your programming language
        Join the segments with '/'
        Append this to the purl"
		aStream nextPut: $#.
		aStream nextPutAll:
			($/ join: (($/ split: subpath) collect: #urlEncoded)) ]
]

{ #category : #printing }
PackageUrl >> printOn: aStream [

	self printCanonicalOn: aStream
]

{ #category : #accessing }
PackageUrl >> qualifiers [
	^ qualifiers
]

{ #category : #initialization }
PackageUrl >> sanitize [

	type = 'bitbucket' ifTrue: [ self sanitizeBitbucket ].
	type = 'deb' ifTrue: [ self sanitizeDebian ].
	type = 'github' ifTrue: [ self sanitizeGithub ].
	type = 'golang' ifTrue: [ self sanitizeGolang ].
	type = 'hex' ifTrue: [ self sanitizeHex ].
	type = 'npm' ifTrue: [ self sanitizeNpm ].
	type = 'pypi' ifTrue: [ self sanitizePypi ].
	type = 'rpm' ifTrue: [ self sanitizeRpm  ].

]

{ #category : #initialization }
PackageUrl >> sanitizeBitbucket [

	namespace := namespace asLowercase.
	name := name asLowercase
]

{ #category : #initialization }
PackageUrl >> sanitizeDebian [

	namespace := namespace asLowercase.
	name := name asLowercase
]

{ #category : #initialization }
PackageUrl >> sanitizeGithub [

	namespace := namespace asLowercase.
	name := name asLowercase
]

{ #category : #initialization }
PackageUrl >> sanitizeGolang [

	namespace := namespace asLowercase.
	name := name asLowercase
]

{ #category : #initialization }
PackageUrl >> sanitizeHex [

	namespace := namespace asLowercase.
	name := name asLowercase
]

{ #category : #initialization }
PackageUrl >> sanitizeNpm [

	name := name asLowercase
]

{ #category : #initialization }
PackageUrl >> sanitizePypi [

	name := name asLowercase replaceAll: $_ with: $-
]

{ #category : #initialization }
PackageUrl >> sanitizeRpm [

	namespace := namespace asLowercase
]

{ #category : #initialization }
PackageUrl >> setType: aType namespace: aNamespace name: aName version: aVersion qualifiers: aDictionary subpath: aSubpath [

	type := aType.
	namespace := aNamespace.
	name := aName.
	version := aVersion.
	qualifiers := aDictionary.
	subpath := aSubpath
]

{ #category : #accessing }
PackageUrl >> subpath [
	^ subpath
]

{ #category : #accessing }
PackageUrl >> type [
	^ type
]

{ #category : #accessing }
PackageUrl >> version [
	^ version
]
