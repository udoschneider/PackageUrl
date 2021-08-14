Class {
	#name : #PUrlTestsuiteTests,
	#superclass : #TestCase,
	#category : #'PackageUrl-Tests'
}

{ #category : #tests }
PUrlTestsuiteTests >> testANameIsRequired [

	"a name is required"

	self
		should: [ PUrl fromString: 'pkg:maven/@1.3.4' ]
		raise: PUrlError
		description: 'should raise: a name is required'
]

{ #category : #tests }
PUrlTestsuiteTests >> testASchemeIsAlwaysRequired [

	"a scheme is always required"

	self
		should: [ PUrl fromString: 'EnterpriseLibrary.Common@6.0.1304' ]
		raise: PUrlError
		description: 'should raise: a scheme is always required'
]

{ #category : #tests }
PUrlTestsuiteTests >> testATypeIsAlwaysRequired [

	"a type is always required"

	self
		should: [ PUrl fromString: 'pkg:EnterpriseLibrary.Common@6.0.1304' ]
		raise: PUrlError
		description: 'should raise: a type is always required'
]

{ #category : #tests }
PUrlTestsuiteTests >> testBasicValidMavenPurlWithoutVersion [

	"basic valid maven purl without version"

	| purl |
	purl := PUrl fromString: 'pkg:maven/org.apache.commons/io'.
	self assert: purl type equals: 'maven'.
	self assert: purl namespace equals: 'org.apache.commons'.
	self assert: purl name equals: 'io'.
	self assert: purl version equals: nil.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: nil.
	self assert: purl canonical equals: 'pkg:maven/org.apache.commons/io'
]

{ #category : #tests }
PUrlTestsuiteTests >> testBitbucketNamespaceAndNameShouldBeLowercased [

	"bitbucket namespace and name should be lowercased"

	| purl |
	purl := PUrl fromString:
		        'pkg:bitbucket/birKenfeld/pyGments-main@244fd47e07d1014f0aed9c'.
	self assert: purl type equals: 'bitbucket'.
	self assert: purl namespace equals: 'birkenfeld'.
	self assert: purl name equals: 'pygments-main'.
	self assert: purl version equals: '244fd47e07d1014f0aed9c'.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals:
		'pkg:bitbucket/birkenfeld/pygments-main@244fd47e07d1014f0aed9c'
]

{ #category : #tests }
PUrlTestsuiteTests >> testChecksForInvalidQualifierKeys [

	"checks for invalid qualifier keys"

	self
		should: [ 
		PUrl fromString: 'pkg:npm/myartifact@1.0.0?in%20production=true' ]
		raise: PUrlError
		description: 'should raise: checks for invalid qualifier keys'
]

{ #category : #tests }
PUrlTestsuiteTests >> testDebianCanUseQualifiers [

	"debian can use qualifiers"

	| purl |
	purl := PUrl fromString:
		        'pkg:deb/debian/curl@7.50.3-1?arch=i386&distro=jessie'.
	self assert: purl type equals: 'deb'.
	self assert: purl namespace equals: 'debian'.
	self assert: purl name equals: 'curl'.
	self assert: purl version equals: '7.50.3-1'.
	self assert: purl qualifiers equals: (Dictionary new
			 add: 'distro' -> 'jessie';
			 add: 'arch' -> 'i386';
			 yourself).
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals: 'pkg:deb/debian/curl@7.50.3-1?arch=i386&distro=jessie'
]

{ #category : #tests }
PUrlTestsuiteTests >> testDockerUsesQualifiersAndHashImageIdAsVersions [

	"docker uses qualifiers and hash image id as versions"

	| purl |
	purl := PUrl fromString:
		        'pkg:docker/customer/dockerimage@sha256:244fd47e07d1004f0aed9c?repository_url=gcr.io'.
	self assert: purl type equals: 'docker'.
	self assert: purl namespace equals: 'customer'.
	self assert: purl name equals: 'dockerimage'.
	self assert: purl version equals: 'sha256:244fd47e07d1004f0aed9c'.
	self assert: purl qualifiers equals: (Dictionary new
			 add: 'repository_url' -> 'gcr.io';
			 yourself).
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals:
		'pkg:docker/customer/dockerimage@sha256:244fd47e07d1004f0aed9c?repository_url=gcr.io'
]

{ #category : #tests }
PUrlTestsuiteTests >> testDoubleSlashAfterSchemeIsNotSignificant [

	"double slash // after scheme is not significant"

	| purl |
	purl := PUrl fromString: 'pkg://maven/org.apache.commons/io'.
	self assert: purl type equals: 'maven'.
	self assert: purl namespace equals: 'org.apache.commons'.
	self assert: purl name equals: 'io'.
	self assert: purl version equals: nil.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: nil.
	self assert: purl canonical equals: 'pkg:maven/org.apache.commons/io'
]

{ #category : #tests }
PUrlTestsuiteTests >> testGithubNamespaceAndNameShouldBeLowercased [

	"github namespace and name should be lowercased"

	| purl |
	purl := PUrl fromString:
		        'pkg:github/Package-url/purl-Spec@244fd47e07d1004f0aed9c'.
	self assert: purl type equals: 'github'.
	self assert: purl namespace equals: 'package-url'.
	self assert: purl name equals: 'purl-spec'.
	self assert: purl version equals: '244fd47e07d1004f0aed9c'.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals: 'pkg:github/package-url/purl-spec@244fd47e07d1004f0aed9c'
]

{ #category : #tests }
PUrlTestsuiteTests >> testJavaGemCanUseAQualifier [

	"Java gem can use a qualifier"

	| purl |
	purl := PUrl fromString: 'pkg:gem/jruby-launcher@1.1.2?Platform=java'.
	self assert: purl type equals: 'gem'.
	self assert: purl namespace equals: nil.
	self assert: purl name equals: 'jruby-launcher'.
	self assert: purl version equals: '1.1.2'.
	self assert: purl qualifiers equals: (Dictionary new
			 add: 'platform' -> 'java';
			 yourself).
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals: 'pkg:gem/jruby-launcher@1.1.2?platform=java'
]

{ #category : #tests }
PUrlTestsuiteTests >> testMavenCanComeWithATypeQualifier [

	"maven can come with a type qualifier"

	| purl |
	purl := PUrl fromString:
		        'pkg:Maven/net.sf.jacob-project/jacob@1.14.3?classifier=x86&type=dll'.
	self assert: purl type equals: 'maven'.
	self assert: purl namespace equals: 'net.sf.jacob-project'.
	self assert: purl name equals: 'jacob'.
	self assert: purl version equals: '1.14.3'.
	self assert: purl qualifiers equals: (Dictionary new
			 add: 'classifier' -> 'x86';
			 add: 'type' -> 'dll';
			 yourself).
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals:
		'pkg:maven/net.sf.jacob-project/jacob@1.14.3?classifier=x86&type=dll'
]

{ #category : #tests }
PUrlTestsuiteTests >> testMavenOftenUsesQualifiers [

	"maven often uses qualifiers"

	| purl |
	purl := PUrl fromString:
		        'pkg:Maven/org.apache.xmlgraphics/batik-anim@1.9.1?classifier=sources&repositorY_url=repo.spring.io/release'.
	self assert: purl type equals: 'maven'.
	self assert: purl namespace equals: 'org.apache.xmlgraphics'.
	self assert: purl name equals: 'batik-anim'.
	self assert: purl version equals: '1.9.1'.
	self assert: purl qualifiers equals: (Dictionary new
			 add: 'classifier' -> 'sources';
			 add: 'repository_url' -> 'repo.spring.io/release';
			 yourself).
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals:
		'pkg:maven/org.apache.xmlgraphics/batik-anim@1.9.1?classifier=sources&repository_url=repo.spring.io/release'
]

{ #category : #tests }
PUrlTestsuiteTests >> testMavenPomReference [

	"maven pom reference"

	| purl |
	purl := PUrl fromString:
		        'pkg:Maven/org.apache.xmlgraphics/batik-anim@1.9.1?extension=pom&repositorY_url=repo.spring.io/release'.
	self assert: purl type equals: 'maven'.
	self assert: purl namespace equals: 'org.apache.xmlgraphics'.
	self assert: purl name equals: 'batik-anim'.
	self assert: purl version equals: '1.9.1'.
	self assert: purl qualifiers equals: (Dictionary new
			 add: 'repository_url' -> 'repo.spring.io/release';
			 add: 'extension' -> 'pom';
			 yourself).
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals:
		'pkg:maven/org.apache.xmlgraphics/batik-anim@1.9.1?extension=pom&repository_url=repo.spring.io/release'
]

{ #category : #tests }
PUrlTestsuiteTests >> testNpmCanBeScoped [

	"npm can be scoped"

	| purl |
	purl := PUrl fromString: 'pkg:npm/%40angular/animation@12.3.1'.
	self assert: purl type equals: 'npm'.
	self assert: purl namespace equals: '@angular'.
	self assert: purl name equals: 'animation'.
	self assert: purl version equals: '12.3.1'.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals: 'pkg:npm/%40angular/animation@12.3.1'
]

{ #category : #tests }
PUrlTestsuiteTests >> testNugetNamesAreCaseSensitive [

	"nuget names are case sensitive"

	| purl |
	purl := PUrl fromString:
		        'pkg:Nuget/EnterpriseLibrary.Common@6.0.1304'.
	self assert: purl type equals: 'nuget'.
	self assert: purl namespace equals: nil.
	self assert: purl name equals: 'EnterpriseLibrary.Common'.
	self assert: purl version equals: '6.0.1304'.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals: 'pkg:nuget/EnterpriseLibrary.Common@6.0.1304'
]

{ #category : #tests }
PUrlTestsuiteTests >> testPypiNamesHaveSpecialRulesAndNotCaseSensitive [

	"pypi names have special rules and not case sensitive"

	| purl |
	purl := PUrl fromString: 'pkg:PYPI/Django_package@1.11.1.dev1'.
	self assert: purl type equals: 'pypi'.
	self assert: purl namespace equals: nil.
	self assert: purl name equals: 'django-package'.
	self assert: purl version equals: '1.11.1.dev1'.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals: 'pkg:pypi/django-package@1.11.1.dev1'
]

{ #category : #tests }
PUrlTestsuiteTests >> testRpmOftenUseQualifiers [

	"rpm often use qualifiers"

	| purl |
	purl := PUrl fromString:
		        'pkg:Rpm/fedora/curl@7.50.3-1.fc25?Arch=i386&Distro=fedora-25'.
	self assert: purl type equals: 'rpm'.
	self assert: purl namespace equals: 'fedora'.
	self assert: purl name equals: 'curl'.
	self assert: purl version equals: '7.50.3-1.fc25'.
	self assert: purl qualifiers equals: (Dictionary new
			 add: 'distro' -> 'fedora-25';
			 add: 'arch' -> 'i386';
			 yourself).
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals:
		'pkg:rpm/fedora/curl@7.50.3-1.fc25?arch=i386&distro=fedora-25'
]

{ #category : #tests }
PUrlTestsuiteTests >> testSlashAfterSchemeIsNotSignificant [

	"slash / after scheme is not significant"

	| purl |
	purl := PUrl fromString: 'pkg:/maven/org.apache.commons/io'.
	self assert: purl type equals: 'maven'.
	self assert: purl namespace equals: 'org.apache.commons'.
	self assert: purl name equals: 'io'.
	self assert: purl version equals: nil.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: nil.
	self assert: purl canonical equals: 'pkg:maven/org.apache.commons/io'
]

{ #category : #tests }
PUrlTestsuiteTests >> testSlashAfterTypeIsNotSignificant [

	"slash /// after type  is not significant"

	| purl |
	purl := PUrl fromString: 'pkg:///maven/org.apache.commons/io'.
	self assert: purl type equals: 'maven'.
	self assert: purl namespace equals: 'org.apache.commons'.
	self assert: purl name equals: 'io'.
	self assert: purl version equals: nil.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: nil.
	self assert: purl canonical equals: 'pkg:maven/org.apache.commons/io'
]

{ #category : #tests }
PUrlTestsuiteTests >> testValidGoPurlWithVersionAndSubpath [

	"valid go purl with version and subpath"

	| purl |
	purl := PUrl fromString:
		        'pkg:GOLANG/google.golang.org/genproto@abcdedf#/googleapis/api/annotations/'.
	self assert: purl type equals: 'golang'.
	self assert: purl namespace equals: 'google.golang.org'.
	self assert: purl name equals: 'genproto'.
	self assert: purl version equals: 'abcdedf'.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: 'googleapis/api/annotations'.
	self
		assert: purl canonical
		equals:
		'pkg:golang/google.golang.org/genproto@abcdedf#googleapis/api/annotations'
]

{ #category : #tests }
PUrlTestsuiteTests >> testValidGoPurlWithoutVersionAndWithSubpath [

	"valid go purl without version and with subpath"

	| purl |
	purl := PUrl fromString:
		        'pkg:GOLANG/google.golang.org/genproto#/googleapis/api/annotations/'.
	self assert: purl type equals: 'golang'.
	self assert: purl namespace equals: 'google.golang.org'.
	self assert: purl name equals: 'genproto'.
	self assert: purl version equals: nil.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: 'googleapis/api/annotations'.
	self
		assert: purl canonical
		equals:
		'pkg:golang/google.golang.org/genproto#googleapis/api/annotations'
]

{ #category : #tests }
PUrlTestsuiteTests >> testValidMavenPurl [

	"valid maven purl"

	| purl |
	purl := PUrl fromString: 'pkg:maven/org.apache.commons/io@1.3.4'.
	self assert: purl type equals: 'maven'.
	self assert: purl namespace equals: 'org.apache.commons'.
	self assert: purl name equals: 'io'.
	self assert: purl version equals: '1.3.4'.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals: 'pkg:maven/org.apache.commons/io@1.3.4'
]

{ #category : #tests }
PUrlTestsuiteTests >> testValidMavenPurlContainingASpaceInTheVersionAndQualifier [

	"valid maven purl containing a space in the version and qualifier"

	| purl |
	purl := PUrl fromString:
		        'pkg:maven/mygroup/myartifact@1.0.0%20Final?mykey=my%20value'.
	self assert: purl type equals: 'maven'.
	self assert: purl namespace equals: 'mygroup'.
	self assert: purl name equals: 'myartifact'.
	self assert: purl version equals: '1.0.0 Final'.
	self assert: purl qualifiers equals: (Dictionary new
			 add: 'mykey' -> 'my value';
			 yourself).
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals:
		'pkg:maven/mygroup/myartifact@1.0.0%20Final?mykey=my%20value'
]

{ #category : #tests }
PUrlTestsuiteTests >> testValidMavenPurlWithCaseSensitiveNamespaceAndName [

	"valid maven purl with case sensitive namespace and name"

	| purl |
	purl := PUrl fromString: 'pkg:maven/HTTPClient/HTTPClient@0.3-3'.
	self assert: purl type equals: 'maven'.
	self assert: purl namespace equals: 'HTTPClient'.
	self assert: purl name equals: 'HTTPClient'.
	self assert: purl version equals: '0.3-3'.
	self assert: purl qualifiers equals: nil.
	self assert: purl subpath equals: nil.
	self
		assert: purl canonical
		equals: 'pkg:maven/HTTPClient/HTTPClient@0.3-3'
]
