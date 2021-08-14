Extension { #name : #Object }

{ #category : #'*PackageUrl-Core' }
Object >> splitLeft: aSequenceableCollection [

	"split aSequenceableCollection from the left at self"

	| split |
	aSequenceableCollection ifEmpty: [ 
		^ { 
			  aSequenceableCollection species empty.
			  aSequenceableCollection species empty } ].
	split := self split: aSequenceableCollection.
	split size = 1 ifTrue: [ 
		^ { 
			  aSequenceableCollection.
			  aSequenceableCollection species empty } ].

	^ { 
		  split first.
		  (self join: split allButFirst) }
]

{ #category : #'*PackageUrl-Core' }
Object >> splitLeft: aSequenceableCollection leftDo: left rightDo: right [

	| split |
	split := self splitLeft: aSequenceableCollection.
	left value: split first.
	right value: split second
]

{ #category : #'*PackageUrl-Core' }
Object >> splitRight: aSequenceableCollection [

	"split aSequenceableCollection from the right at self"

	| split |
	aSequenceableCollection ifEmpty: [ 
		^ { 
			  aSequenceableCollection species empty.
			  aSequenceableCollection species empty } ].
	split := self split: aSequenceableCollection.
	split size = 1 ifTrue: [ 
		^ { 
			  aSequenceableCollection.
			  aSequenceableCollection species empty } ].

	^ { 
		  (self join: split allButLast).
		  split last }
]

{ #category : #'*PackageUrl-Core' }
Object >> splitRight: aSequenceableCollection leftDo: left rightDo: right [

	| split |
	split := self splitRight: aSequenceableCollection.
	left value: split first.
	right value: split second
]
