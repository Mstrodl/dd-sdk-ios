/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import XCTest
@testable import Datadog

class DDNoopTracerTests: XCTestCase {
    func testWhenUsingDDNoopTracerAPIs_itPrintsWarning() {
        let (old, logger) = dd.replacing(logger: CoreLoggerMock())
        defer { dd = old }

        // Given
        let noop = DDNoopTracer()

        // When
        let context = DDSpanContext.mockAny()
        noop.inject(spanContext: context, writer: HTTPHeadersWriter())
        _ = noop.extract(reader: HTTPHeadersReader(httpHeaderFields: [:]))
        let root = noop.startRootSpan(operationName: "root operation").setActive()
        let child = noop.startSpan(operationName: "child operation")
        child.finish()
        root.finish()

        // Then
        let expectedWarningMessage = """
        The `Global.sharedTracer` was called but no `Tracer` is registered. Configure and register the `Tracer` globally before invoking the feature:
            Global.sharedTracer = Tracer.initialize()
        See https://docs.datadoghq.com/tracing/setup_overview/setup/ios
        """

        XCTAssertEqual(logger.warnLogs.count, 4)
        logger.warnLogs.forEach { log in
            XCTAssertEqual(log.message, expectedWarningMessage)
        }
    }
}
