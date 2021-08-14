Extension { #name : #Character }

{ #category : #'*PackageUrl-Core' }
Character >> isAllowedInPackageUrlKey [

	^ self isAlphaNumeric or: [ '.-_' includes: self ]
]
