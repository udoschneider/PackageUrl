Class {
	#name : #PackageUrlTests,
	#superclass : #TestCase,
	#category : #'PackageUrl-Tests'
}

{ #category : #tests }
PackageUrlTests >> testDocker [

	| purl |
	purl := PackageUrl dockerImageNamed: 'alpine'.
	self assert: purl canonical equals: 'pkg:docker/alpine'.
	purl := PackageUrl dockerImageNamed: 'alpine' version: '3.11.11'.
	self assert: purl canonical equals: 'pkg:docker/alpine@3.11.11'
]
