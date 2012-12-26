//
//  Defines.h
//  MasterLocking
//
//  Created by Phien Tram on 11/19/12.
//  Copyright (c) 2012 Golden Key. All rights reserved.
//

#ifndef MasterLocking_Defines_h
#define MasterLocking_Defines_h

#define MAX_DISTANCE    30.0

#define LOCK_SERVICE_UUID               @"FFF0"
#define READ_CHARACTERISTIC_UUID        @"FFF1"
#define WRITE_CHARACTERISTIC_UUID       @"FFF2"
#define IO_CHARACTERISTIC_LENGTH        4

#define k_command_wakeup    0x00
#define k_command_unlock    0x01
#define k_command_lock      0x02

#define OBJ_ICON_SIZE   30

typedef enum {
    BikeStatusNone,
    BikeStatusParking,
    BikeStatusStop,
    BikeStatusDriving,
    BikeStatusExcessiveVelocity,
    BikeStatusLostGPS,
    BikeStatusLostGSM,
    BikeStatusSize
} BikeStatus;

#endif
