//
//  DateUtilsSpec.swift
//  Snap
//
//  Created by Daniel Marcenco on 10/12/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import Quick
import Nimble

@testable import Snap

class DateUtilsSpec: QuickSpec {
    override func spec() {
        describe("Date formatter should convert date to expected format") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyy"

            let myDate = "12 Oct 2016"
            let expectedDate = dateFormatter.date(from: myDate)

            expect(myDate).to(equal(dateFormatter.string(from: expectedDate!)))
        }
    }
}
