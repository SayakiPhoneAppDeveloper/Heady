//
//  DateFormatter+Extension.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation
extension DateFormatter{
    static let dateFormatr: DateFormatter = {
        let _dateFormatter = DateFormatter()
        //        2016-11-05T11:16:11.000Z
        _dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        _dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return _dateFormatter
    }()
}
