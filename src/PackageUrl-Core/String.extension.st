Extension { #name : #String }

{ #category : #'*PackageUrl-Core' }
String >> purlDecoded [


	^ PurlPercentEncoder new decode: self
]

{ #category : #'*PackageUrl-Core' }
String >> purlEncoded [

	

	^ PurlPercentEncoder new encode: self
]

{ #category : #'*PackageUrl-Core' }
String >> trimSlashes [
^self trimBoth: [ :each | each =$/ ]
]
