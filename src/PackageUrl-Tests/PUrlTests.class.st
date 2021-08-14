Class {
	#name : #PUrlTests,
	#superclass : #TestCase,
	#category : #'PackageUrl-Tests'
}

{ #category : #private }
PUrlTests >> asserSplitLeft: aSequenceableCollection separator: separator left: left right: right [

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
PUrlTests >> asserSplitRightt: aSequenceableCollection separator: separator left: left right: right [

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
PUrlTests >> testLeftEmpty [

	self
		asserSplitLeft: ''
		separator: $/
		left: ''
		right: ''
]

{ #category : #tests }
PUrlTests >> testLeftMultipleSeparators [

	self
		asserSplitLeft: 'left/right1/right/right3'
		separator: $/
		left: 'left'
		right: 'right1/right/right3'
]

{ #category : #tests }
PUrlTests >> testLeftNoSeparator [

	self
		asserSplitLeft: 'value'
		separator: $/
		left: 'value'
		right: ''
]

{ #category : #tests }
PUrlTests >> testLeftOneSeparator [

	self
		asserSplitLeft: 'left/right'
		separator: $/
		left: 'left'
		right: 'right'
]

{ #category : #tests }
PUrlTests >> testRightEmpty [


self
		asserSplitRightt: ''
		separator: $/
		left: ''
		right: ''
]

{ #category : #tests }
PUrlTests >> testRightMultipleSeparators [

	self
		asserSplitRightt: 'left1/left2/left3/right'
		separator: $/
		left: 'left1/left2/left3'
		right: 'right'
]

{ #category : #tests }
PUrlTests >> testRightNoSeparator [

	self
		asserSplitRightt: 'value'
		separator: $/
		left: 'value'
		right: ''
]

{ #category : #tests }
PUrlTests >> testRightOneSeparator [

	self
		asserSplitRightt: 'left/right'
		separator: $/
		left: 'left'
		right: 'right'
]
