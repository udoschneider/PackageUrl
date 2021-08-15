Extension { #name : #String }

{ #category : #'*PackageUrl-Core' }
String >> packageUrlDecoded [


	^ PackageUrlPercentEncoder new decode: self
]

{ #category : #'*PackageUrl-Core' }
String >> packageUrlEncoded [

	

	^ PackageUrlPercentEncoder new encode: self
]

{ #category : #'*PackageUrl-Core' }
String >> trimSlashes [
^self trimBoth: [ :each | each =$/ ]
]
