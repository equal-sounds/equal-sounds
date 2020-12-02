//
//  Thread+Async.swift
//  equal sounds
//
//  Created by Gray, John Walker on 12/2/20.
//

/*
 Convenience utilities for threading
 */

import Foundation

// macro (I guess?) for executing code in a background thread
func async(completion: @escaping ()->())
{
    DispatchQueue.global(qos: .background).schedule
    {
        completion()
    }
}

// macro for executing code in the main UI thread
func sync(completion: @escaping ()->())
{
    DispatchQueue.global(qos: .userInteractive).schedule
    {
        completion()
    }
}
