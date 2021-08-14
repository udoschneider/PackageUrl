Class {
	#name : #PUrlTests,
	#superclass : #TestCase,
	#category : #'PackageUrl-Tests'
}

{ #category : #tests }
PUrlTests >> testDocker [

	| purl |
	purl := PUrl dockerImageNamed: 'alpine'.
	self assert: purl canonical equals: 'pkg:docker/alpine@latest'.
		purl := PUrl dockerImageNamed: 'alpine' version: '3.11.11'.
	self assert: purl canonical equals: 'pkg:docker/alpine@3.11.11'
]
