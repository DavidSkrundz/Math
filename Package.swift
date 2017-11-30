// swift-tools-version:4.0
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
			type: .static,
			targets: ["Math"]),
		.library(
			name: "Math",
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
