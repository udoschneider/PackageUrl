Class {
	#name : #PackageUrlExtensionTests,
	#superclass : #TestCase,
	#category : #'PackageUrl-Tests'
}

{ #category : #private }
PackageUrlExtensionTests >> asserSplitLeft: aSequenceableCollection separator: separator left: left right: right [

	| split |
	split := separator splitLeft: aSequenceableCollection.
	self assert: split first equals: left.
	self assert: split second equals: right.

	separator
		splitLeft: aSequenceableCollection
		leftDo: [ :value | self assert: value equals: left ]
		rightDo: [ :value | 
		self assert: value equals: right ]
]

{ #category : #private }
PackageUrlExtensionTests >> asserSplitRightt: aSequenceableCollection separator: separator left: left right: right [

	| split |
	split := separator splitRight: aSequenceableCollection.
	self assert: split first equals: left.
	self assert: split second equals: right.

	separator
		splitRight: aSequenceableCollection
		leftDo: [ :value | self assert: value equals: left ]
		rightDo: [ :value | self assert: value equals: right ]
]

{ #category : #tests }
PackageUrlExtensionTests >> testLeftEmpty [

	self
		asserSplitLeft: ''
		separator: $/
		left: ''
		right: ''
]

{ #category : #tests }
PackageUrlExtensionTests >> testLeftMultipleSeparators [

	self
		asserSplitLeft: 'left/right1/right/right3'
		separator: $/
		left: 'left'
		right: 'right1/right/right3'
]

{ #category : #tests }
PackageUrlExtensionTests >> testLeftNoSeparator [

	self
		asserSplitLeft: 'value'
		separator: $/
		left: 'value'
		right: ''
]

{ #category : #tests }
PackageUrlExtensionTests >> testLeftOneSeparator [

	self
		asserSplitLeft: 'left/right'
		separator: $/
		left: 'left'
		right: 'right'
]

{ #category : #tests }
PackageUrlExtensionTests >> testRightEmpty [


self
		asserSplitRightt: ''
		separator: $/
		left: ''
		right: ''
]

{ #category : #tests }
PackageUrlExtensionTests >> testRightMultipleSeparators [

	self
		asserSplitRightt: 'left1/left2/left3/right'
		separator: $/
		left: 'left1/left2/left3'
		right: 'right'
]

{ #category : #tests }
PackageUrlExtensionTests >> testRightNoSeparator [

	self
		asserSplitRightt: 'value'
		separator: $/
		left: 'value'
		right: ''
]

{ #category : #tests }
PackageUrlExtensionTests >> testRightOneSeparator [

	self
		asserSplitRightt: 'left/right'
		separator: $/
		left: 'left'
		right: 'right'
]
