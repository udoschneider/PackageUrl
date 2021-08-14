Class {
	#name : #PUrlTestsuiteTest,
	#superclass : #Object,
	#instVars : [
		'description',
		'purl',
		'type',
		'namespace',
		'name',
		'version',
		'qualifiers',
		'subpath',
		'isInvalid',
		'canonicalPurl',
		'testMethodName'
	],
	#category : #'PackageUrl-TestsuiteBuilder'
}

{ #category : #accessing }
PUrlTestsuiteTest class >> neoJsonMapping: mapper [

	mapper for: self do: [ :mapping | 
		mapping mapInstVars:
			#( description purl canonicalPurl type namespace name version
			   qualifiers subpath isInvalid ).
		mapping mapInstVar: #canonicalPurl to: 'canonical_purl'.
		mapping mapInstVar: #isInvalid to: 'is_invalid' ]
]

{ #category : #private }
PUrlTestsuiteTest >> emitAssertion: property equals: value to: aStream [

	aStream
		nextPutAll: 'self assert: purl ';
		nextPutAll: property;
		nextPutAll: ' equals: ';
		print: value;
		nextPutAll: '.';
		cr
]

{ #category : #private }
PUrlTestsuiteTest >> emitAssertion: property equalsDictionary: value to: aStream [

	aStream
		nextPutAll: 'self assert: purl ';
		nextPutAll: property;
		nextPutAll: ' equals: '.
	value storeOn: aStream.
	aStream
		nextPutAll: '.';
		cr
]

{ #category : #private }
PUrlTestsuiteTest >> emitAssertions: aStream [

	isInvalid
		ifTrue: [ self emitInvalidAssertion: aStream ]
		ifFalse: [ self emitValidAssertions: aStream ]
]

{ #category : #private }
PUrlTestsuiteTest >> emitInvalidAssertion: aStream [

	aStream
		nextPutAll: 'self should: [';
		nextPutAll: 'PUrl fromString: ''';
		nextPutAll: purl;
		nextPutAll: '''] raise: PUrlError description: ';
		print: 'should raise: ' , description;
		nextPut: $.;
		cr
]

{ #category : #private }
PUrlTestsuiteTest >> emitMethodHeader: aStream [

	aStream
		nextPutAll: '|purl|';
		cr.
	aStream
		nextPutAll: 'purl := PUrl fromString: ''';
		nextPutAll: purl;
		nextPutAll: '''.';
		cr
]

{ #category : #private }
PUrlTestsuiteTest >> emitMethodSignature: aStream [

	aStream
		nextPutAll: self testMethodName;
		cr
]

{ #category : #private }
PUrlTestsuiteTest >> emitTestComment: aStream [

	description isNil ifTrue: [ ^ self ].
	self printCleanedComment: description to: aStream.
	aStream cr
]

{ #category : #private }
PUrlTestsuiteTest >> emitValidAssertions: aStream [

	self
		emitMethodHeader: aStream;
		emitAssertion: 'type' equals: type to: aStream;
		emitAssertion: 'namespace' equals: namespace to: aStream;
		emitAssertion: 'name' equals: name to: aStream;
		emitAssertion: 'version' equals: version to: aStream;
		emitAssertion: 'qualifiers'
		equalsDictionary: qualifiers
		to: aStream;
		emitAssertion: 'subpath' equals: subpath to: aStream;
		emitAssertion: 'canonical' equals: canonicalPurl to: aStream
]

{ #category : #'code generation' }
PUrlTestsuiteTest >> generateCode: aClass [

	| methodName methodContent |
	methodContent := String streamContents: [ :stream | 
		                 self
			                 emitMethodSignature: stream;
			                 emitTestComment: stream;
			                 emitAssertions: stream ].

	methodName := aClass compile: methodContent.
	(aClass >> methodName)
		reformat;
		protocol: 'tests'
]

{ #category : #private }
PUrlTestsuiteTest >> printCleanedComment: aString to: aStream [

	aStream nextPut: $".
	aString do: [ :each | 
		each = $"
			ifFalse: [ aStream nextPut: each ]
			ifTrue: [ aStream nextPut: $' ] ].
	aStream nextPut: $"
]

{ #category : #accessing }
PUrlTestsuiteTest >> testMethodName [

	^ testMethodName ifNil: [ 
		  | cleanedDescription |
		  cleanedDescription := '' join:
			                        (([ :character | 
			                          character isAlphaNumeric not ] split:
				                          description) collect: [ :each | 
				                         each capitalized ]).
		  testMethodName := 'test' , cleanedDescription ]
]
