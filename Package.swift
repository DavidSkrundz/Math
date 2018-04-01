// swift-tools-version:4.1
//
//  Package.swift
//  Math
//

import PackageDescription

let package = Package(
	name: "Math",
	products: [
		.library(
			name: "Math",
			targets: ["Math"]),
		.library(
			name: "sMath",
			type: .static,
			targets: ["Math"]),
		.library(
			name: "dMath",
			type: .dynamic,
			targets: ["Math"])
	],
	targets: [
		.target(
			name: "Math",
			dependencies: []),
		.testTarget(
			name: "MathTests",
			dependencies: ["Math"])
	]
)
