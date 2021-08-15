Class {
	#name : #PackageUrlTests,
	#superclass : #TestCase,
	#instVars : [
		'purl1'
	],
	#category : #'PackageUrl-Tests'
}

{ #category : #tests }
PackageUrlTests >> testDockerImageIdentifier [

	| purl |
	purl := PackageUrl dockerName: 'alpine'.
	self assert: purl dockerIdentifier equals: 'alpine'.
	purl := PackageUrl dockerName: 'alpine' version: '3.11.11'.
	self assert: purl dockerIdentifier equals: 'alpine:3.11.11'.
	purl := PackageUrl
		        dockerRepository: 'my.repository.com:500'
		        name: 'alpine'
		        version: '3.11.11'.
	self assert: purl dockerIdentifier equals: 'my.repository.com:500/alpine:3.11.11'
]

{ #category : #tests }
PackageUrlTests >> testEmptyQualifier [

	"debian can use qualifiers"

	| purl |
	purl := PackageUrl fromString:
		        'pkg:deb/debian/curl@7.50.3-1?arch=i386&distro=jessie&key&'.
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
PackageUrlTests >> testFromDocker [

	| purl |
	purl := PackageUrl dockerName: 'alpine'.
	self assert: purl canonical equals: 'pkg:docker/alpine'.
	purl := PackageUrl dockerName: 'alpine' version: '3.11.11'.
	self assert: purl canonical equals: 'pkg:docker/alpine@3.11.11'.
	purl := PackageUrl
		        dockerRepository: 'my.repository.com:500'
		        name: 'alpine'
		        version: '3.11.11'.
	self
		assert: purl canonical
		equals: 'pkg:docker/my.repository.com%3A500/alpine@3.11.11'
]

{ #category : #tests }
PackageUrlTests >> testHashEquality [

	| purl2 purl3 |
	purl1 := PackageUrl fromString:
		         'pkg:deb/debian/curl@7.50.3-1?arch=i386&distro=jessie'.
	purl2 := PackageUrl fromString:
		         'pkg:deb/debian/curl@7.50.3-1?distro=jessie&arch=i386&'.
		purl3 := PackageUrl fromString:
		         'pkg:deb/debian/curl@7.49.3-1?distro=jessie&arch=i386&'.
	self
		assert: purl1 equals: purl2;
		assert: purl1 hash equals: purl2 hash.
			self
		deny: purl1 equals: purl3;
		deny: purl1 hash equals: purl3 hash
]
