/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-Present Datadog, Inc.
 */

import XCTest
@testable import Datadog

class GlobalTests: XCTestCase {
    func testWhenTracerIsNotInitialized_itGivesNoOpImplementation() {
        XCTAssertTrue(Global.sharedTracer is DDNoopTracer)
    }

    func testWhenRUMMonitorIsNotInitialized_itGivesNoOpImplementation() {
        XCTAssertTrue(Global.rum is DDNoopRUMMonitor)
    }

    func testDDGlobalIsGlobalTypealias() {
        XCTAssertTrue(DDGlobal.self == Global.self)
    }
}
