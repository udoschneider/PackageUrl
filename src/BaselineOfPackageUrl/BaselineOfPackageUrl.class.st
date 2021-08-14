Class {
	#name : #BaselineOfPackageUrl,
	#superclass : #BaselineOf,
	#category : #BaselineOfPackageUrl
}

{ #category : #baselines }
BaselineOfPackageUrl >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			package: 'PackageUrl-Core';
			package: 'PackageUrl-Tests'
			with: [ spec requires: #( 'PackageUrl-Core' ) ];
			package: 'PackageUrl-TestsuiteBuilder'
			with: [ spec requires: #( 'PackageUrl-Tests' ) ].

		spec
			group: 'Core' with: #( 'PackageUrl-Core' );
			group: 'Tests' with: #( 'PackageUrl-Tests' );
			group: 'TestsuiteBuilder' with: #( 'PackageUrl-TestsuiteBuilder' ) ]
]
