Class {
	#name : #PUrlExtensionTests,
	#superclass : #TestCase,
	#category : #'PackageUrl-Tests'
}

{ #category : #private }
PUrlExtensionTests >> asserSplitLeft: aSequenceableCollection separator: separator left: left right: right [

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
PUrlExtensionTests >> asserSplitRightt: aSequenceableCollection separator: separator left: left right: right [

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
PUrlExtensionTests >> testLeftEmpty [

	self
		asserSplitLeft: ''
		separator: $/
		left: ''
		right: ''
]

{ #category : #tests }
PUrlExtensionTests >> testLeftMultipleSeparators [

	self
		asserSplitLeft: 'left/right1/right/right3'
		separator: $/
		left: 'left'
		right: 'right1/right/right3'
]

{ #category : #tests }
PUrlExtensionTests >> testLeftNoSeparator [

	self
		asserSplitLeft: 'value'
		separator: $/
		left: 'value'
		right: ''
]

{ #category : #tests }
PUrlExtensionTests >> testLeftOneSeparator [

	self
		asserSplitLeft: 'left/right'
		separator: $/
		left: 'left'
		right: 'right'
]

{ #category : #tests }
PUrlExtensionTests >> testRightEmpty [


self
		asserSplitRightt: ''
		separator: $/
		left: ''
		right: ''
]

{ #category : #tests }
PUrlExtensionTests >> testRightMultipleSeparators [

	self
		asserSplitRightt: 'left1/left2/left3/right'
		separator: $/
		left: 'left1/left2/left3'
		right: 'right'
]

{ #category : #tests }
PUrlExtensionTests >> testRightNoSeparator [

	self
		asserSplitRightt: 'value'
		separator: $/
		left: 'value'
		right: ''
]

{ #category : #tests }
PUrlExtensionTests >> testRightOneSeparator [

	self
		asserSplitRightt: 'left/right'
		separator: $/
		left: 'left'
		right: 'right'
]
