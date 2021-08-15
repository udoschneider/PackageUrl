Class {
	#name : #PackageUrlPercentEncoder,
	#superclass : #ZnPercentEncoder,
	#category : #'PackageUrl-Core'
}

{ #category : #accessing }
PackageUrlPercentEncoder class >> purlUnreservedCharacters [

	^ self rfc3986UnreservedCharacters , '/:'
]

{ #category : #accessing }
PackageUrlPercentEncoder >> safeSet [

	"Return the safe set of characters that I will not encode, as a byte array.
	If not set, I will default to the most commonly used safe set"

	^ safeSet ifNil: [ 
		  safeSet := self class purlUnreservedCharacters asByteArray ]
]
