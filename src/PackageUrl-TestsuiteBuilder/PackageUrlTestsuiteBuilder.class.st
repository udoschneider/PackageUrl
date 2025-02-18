Class {
	#name : #PackageUrlTestsuiteBuilder,
	#superclass : #Object,
	#instVars : [
		'tests',
		'archive',
		'files',
		'testSuiteFile'
	],
	#category : #'PackageUrl-TestsuiteBuilder'
}

{ #category : #constants }
PackageUrlTestsuiteBuilder class >> downloadTestSuiteDataJson [

	^ [ (ZnEasy get: self url) contents ] asJob
		  title: 'Dowbload Package URL Test Suite ...';
		  run
]

{ #category : #actions }
PackageUrlTestsuiteBuilder class >> generateTestCases [

	^ self new
		  generateTestCases;
		  validateGeneratedTestCases
]

{ #category : #actions }
PackageUrlTestsuiteBuilder class >> removeTestCases [

	PackageUrlTestsuite removeFromSystem
]

{ #category : #constants }
PackageUrlTestsuiteBuilder class >> staticTestSuiteDataJson [

	^ '[
  {
    "description": "valid maven purl",
    "purl": "pkg:maven/org.apache.commons/io@1.3.4",
    "canonical_purl": "pkg:maven/org.apache.commons/io@1.3.4",
    "type": "maven",
    "namespace": "org.apache.commons",
    "name": "io",
    "version": "1.3.4",
    "qualifiers": null,
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "basic valid maven purl without version",
    "purl": "pkg:maven/org.apache.commons/io",
    "canonical_purl": "pkg:maven/org.apache.commons/io",
    "type": "maven",
    "namespace": "org.apache.commons",
    "name": "io",
    "version": null,
    "qualifiers": null,
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "valid go purl without version and with subpath",
    "purl": "pkg:GOLANG/google.golang.org/genproto#/googleapis/api/annotations/",
    "canonical_purl": "pkg:golang/google.golang.org/genproto#googleapis/api/annotations",
    "type": "golang",
    "namespace": "google.golang.org",
    "name": "genproto",
    "version": null,
    "qualifiers": null,
    "subpath": "googleapis/api/annotations",
    "is_invalid": false
  },
  {
    "description": "valid go purl with version and subpath",
    "purl": "pkg:GOLANG/google.golang.org/genproto@abcdedf#/googleapis/api/annotations/",
    "canonical_purl": "pkg:golang/google.golang.org/genproto@abcdedf#googleapis/api/annotations",
    "type": "golang",
    "namespace": "google.golang.org",
    "name": "genproto",
    "version": "abcdedf",
    "qualifiers": null,
    "subpath": "googleapis/api/annotations",
    "is_invalid": false
  },
  {
    "description": "bitbucket namespace and name should be lowercased",
    "purl": "pkg:bitbucket/birKenfeld/pyGments-main@244fd47e07d1014f0aed9c",
    "canonical_purl": "pkg:bitbucket/birkenfeld/pygments-main@244fd47e07d1014f0aed9c",
    "type": "bitbucket",
    "namespace": "birkenfeld",
    "name": "pygments-main",
    "version": "244fd47e07d1014f0aed9c",
    "qualifiers": null,
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "github namespace and name should be lowercased",
    "purl": "pkg:github/Package-url/purl-Spec@244fd47e07d1004f0aed9c",
    "canonical_purl": "pkg:github/package-url/purl-spec@244fd47e07d1004f0aed9c",
    "type": "github",
    "namespace": "package-url",
    "name": "purl-spec",
    "version": "244fd47e07d1004f0aed9c",
    "qualifiers": null,
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "debian can use qualifiers",
    "purl": "pkg:deb/debian/curl@7.50.3-1?arch=i386&distro=jessie",
    "canonical_purl": "pkg:deb/debian/curl@7.50.3-1?arch=i386&distro=jessie",
    "type": "deb",
    "namespace": "debian",
    "name": "curl",
    "version": "7.50.3-1",
    "qualifiers": {"arch": "i386", "distro": "jessie"},
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "docker uses qualifiers and hash image id as versions",
    "purl": "pkg:docker/customer/dockerimage@sha256:244fd47e07d1004f0aed9c?repository_url=gcr.io",
    "canonical_purl": "pkg:docker/customer/dockerimage@sha256:244fd47e07d1004f0aed9c?repository_url=gcr.io",
    "type": "docker",
    "namespace": "customer",
    "name": "dockerimage",
    "version": "sha256:244fd47e07d1004f0aed9c",
    "qualifiers": {"repository_url": "gcr.io"},
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "Java gem can use a qualifier",
    "purl": "pkg:gem/jruby-launcher@1.1.2?Platform=java",
    "canonical_purl": "pkg:gem/jruby-launcher@1.1.2?platform=java",
    "type": "gem",
    "namespace": null,
    "name": "jruby-launcher",
    "version": "1.1.2",
    "qualifiers": {"platform": "java"},
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "maven often uses qualifiers",
    "purl": "pkg:Maven/org.apache.xmlgraphics/batik-anim@1.9.1?classifier=sources&repositorY_url=repo.spring.io/release",
    "canonical_purl": "pkg:maven/org.apache.xmlgraphics/batik-anim@1.9.1?classifier=sources&repository_url=repo.spring.io/release",
    "type": "maven",
    "namespace": "org.apache.xmlgraphics",
    "name": "batik-anim",
    "version": "1.9.1",
    "qualifiers": {"classifier": "sources", "repository_url": "repo.spring.io/release"},
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "maven pom reference",
    "purl": "pkg:Maven/org.apache.xmlgraphics/batik-anim@1.9.1?extension=pom&repositorY_url=repo.spring.io/release",
    "canonical_purl": "pkg:maven/org.apache.xmlgraphics/batik-anim@1.9.1?extension=pom&repository_url=repo.spring.io/release",
    "type": "maven",
    "namespace": "org.apache.xmlgraphics",
    "name": "batik-anim",
    "version": "1.9.1",
    "qualifiers": {"extension": "pom", "repository_url": "repo.spring.io/release"},
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "maven can come with a type qualifier",
    "purl": "pkg:Maven/net.sf.jacob-project/jacob@1.14.3?classifier=x86&type=dll",
    "canonical_purl": "pkg:maven/net.sf.jacob-project/jacob@1.14.3?classifier=x86&type=dll",
    "type": "maven",
    "namespace": "net.sf.jacob-project",
    "name": "jacob",
    "version": "1.14.3",
    "qualifiers": {"classifier": "x86", "type": "dll"},
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "npm can be scoped",
    "purl": "pkg:npm/%40angular/animation@12.3.1",
    "canonical_purl": "pkg:npm/%40angular/animation@12.3.1",
    "type": "npm",
    "namespace": "@angular",
    "name": "animation",
    "version": "12.3.1",
    "qualifiers": null,
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "nuget names are case sensitive",
    "purl": "pkg:Nuget/EnterpriseLibrary.Common@6.0.1304",
    "canonical_purl": "pkg:nuget/EnterpriseLibrary.Common@6.0.1304",
    "type": "nuget",
    "namespace": null,
    "name": "EnterpriseLibrary.Common",
    "version": "6.0.1304",
    "qualifiers": null,
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "pypi names have special rules and not case sensitive",
    "purl": "pkg:PYPI/Django_package@1.11.1.dev1",
    "canonical_purl": "pkg:pypi/django-package@1.11.1.dev1",
    "type": "pypi",
    "namespace": null,
    "name": "django-package",
    "version": "1.11.1.dev1",
    "qualifiers": null,
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "rpm often use qualifiers",
    "purl": "pkg:Rpm/fedora/curl@7.50.3-1.fc25?Arch=i386&Distro=fedora-25",
    "canonical_purl": "pkg:rpm/fedora/curl@7.50.3-1.fc25?arch=i386&distro=fedora-25",
    "type": "rpm",
    "namespace": "fedora",
    "name": "curl",
    "version": "7.50.3-1.fc25",
    "qualifiers": {"arch": "i386", "distro": "fedora-25"},
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "a scheme is always required",
    "purl": "EnterpriseLibrary.Common@6.0.1304",
    "canonical_purl": "EnterpriseLibrary.Common@6.0.1304",
    "type": null,
    "namespace": null,
    "name": "EnterpriseLibrary.Common",
    "version": null,
    "qualifiers": null,
    "subpath": null,
    "is_invalid": true
  },
  {
    "description": "a type is always required",
    "purl": "pkg:EnterpriseLibrary.Common@6.0.1304",
    "canonical_purl": "pkg:EnterpriseLibrary.Common@6.0.1304",
    "type": null,
    "namespace": null,
    "name": "EnterpriseLibrary.Common",
    "version": null,
    "qualifiers": null,
    "subpath": null,
    "is_invalid": true
  },
  {
    "description": "a name is required",
    "purl": "pkg:maven/@1.3.4",
    "canonical_purl": "pkg:maven/@1.3.4",
    "type": "maven",
    "namespace": null,
    "name": null,
    "version": null,
    "qualifiers": null,
    "subpath": null,
    "is_invalid": true
  },
  {
    "description": "slash / after scheme is not significant",
    "purl": "pkg:/maven/org.apache.commons/io",
    "canonical_purl": "pkg:maven/org.apache.commons/io",
    "type": "maven",
    "namespace": "org.apache.commons",
    "name": "io",
    "version": null,
    "qualifiers": null,
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "double slash // after scheme is not significant",
    "purl": "pkg://maven/org.apache.commons/io",
    "canonical_purl": "pkg:maven/org.apache.commons/io",
    "type": "maven",
    "namespace": "org.apache.commons",
    "name": "io",
    "version": null,
    "qualifiers": null,
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "slash /// after type  is not significant",
    "purl": "pkg:///maven/org.apache.commons/io",
    "canonical_purl": "pkg:maven/org.apache.commons/io",
    "type": "maven",
    "namespace": "org.apache.commons",
    "name": "io",
    "version": null,
    "qualifiers": null,
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "valid maven purl with case sensitive namespace and name",
    "purl": "pkg:maven/HTTPClient/HTTPClient@0.3-3",
    "canonical_purl": "pkg:maven/HTTPClient/HTTPClient@0.3-3",
    "type": "maven",
    "namespace": "HTTPClient",
    "name": "HTTPClient",
    "version": "0.3-3",
    "qualifiers": null,
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "valid maven purl containing a space in the version and qualifier",
    "purl": "pkg:maven/mygroup/myartifact@1.0.0%20Final?mykey=my%20value",
    "canonical_purl": "pkg:maven/mygroup/myartifact@1.0.0%20Final?mykey=my%20value",
    "type": "maven",
    "namespace": "mygroup",
    "name": "myartifact",
    "version": "1.0.0 Final",
    "qualifiers": {"mykey": "my value"},
    "subpath": null,
    "is_invalid": false
  },
  {
    "description": "checks for invalid qualifier keys",
    "purl": "pkg:npm/myartifact@1.0.0?in%20production=true",
    "canonical_purl": null,
    "type": "npm",
    "namespace": null,
    "name": "myartifact",
    "version": "1.0.0",
    "qualifiers": {"in production": "true"},
    "subpath": null,
    "is_invalid": true
  }
]
'
]

{ #category : #constants }
PackageUrlTestsuiteBuilder class >> url [

	^ 'https://raw.githubusercontent.com/package-url/purl-spec/master/test-suite-data.json'
]

{ #category : #private }
PackageUrlTestsuiteBuilder >> createClass: packageName [

	^ TestCase
		  subclass: #PackageUrlTestsuite
		  instanceVariableNames: ''
		  classVariableNames: ''
		  package: self packageName
]

{ #category : #actions }
PackageUrlTestsuiteBuilder >> generateTestCases [

	| class |
	[ :job | 
	job max: self tests size.
	class := self createClass: self packageName.
	self tests do: [ :test | 
		job
			increment;
			title: 'Generating #' , test testMethodName.
		test generateCode: class ] ] asJob run
]

{ #category : #accessing }
PackageUrlTestsuiteBuilder >> packageName [

	^ PackageUrlTests category asString
]

{ #category : #accessing }
PackageUrlTestsuiteBuilder >> tests [

	^ tests ifNil: [ 
		  [ 
		  | json |
		  "json := self class downloadTestSuiteDataJson."
		  json := self class staticTestSuiteDataJson.

		  tests := (NeoJSONReader on: json readStream)
			           for: #ArrayOfTests
			           customDo: [ :mapping | 
				           mapping listOfElementSchema: PackageUrlTestsuiteTest ];
			           nextAs: #ArrayOfTests ] asJob
			  title: 'Parsing Package URL Test Suite ...';
			  run ]
]

{ #category : #actions }
PackageUrlTestsuiteBuilder >> validateGeneratedTestCases [

	self assert: [ 
		tests size = PackageUrlTestsuite testSelectors size ]
]
