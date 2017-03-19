//
//  DataBaseManager.swift
//  FMDBWorks
//
//  Created by Chinnu M V on 2/8/17.
//  Copyright © 2017 cicitrus.applicationsatest. All rights reserved.




import UIKit

class DataBaseManager: NSObject {

    
    static let shared: DataBaseManager = DataBaseManager()
    let databaseFileName = "database.sqlite"
    var pathToDatabase: String!
    var database: FMDatabase!
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    /**
     Query Execution. It can used for insertion, updation and deletion queries
     
     @param  query : Statement for execution
     
     @return Boolean value - If success return 'true' , Otherwise return 'false'
     */
    
    
  
    func ExecuteQuery( query : String) -> Bool {
        var executed = false
        
      if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            print(pathToDatabase)
         }
            if database != nil {
                // Open the database.
                if database.open() {
                    do {
                        try database.executeUpdate(query, values: nil)
                        executed = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
           }
       
        
        
        return executed
    }
    
    
    
    
    
    /**
     Opening Database for execution
     
     @param
     
     @return
     */
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        if database != nil {
            if database.open() {
                return true
            }
        }
        return false
    }
    
    
    
    
    
    /**
     Query Execution. It can used for insertion, updation and deletion queries
     
     @param  query : Statement for execution
     
     @return nil
     */
    
    
    
    func ExecuteCommand( query : String) {
        if openDatabase() {
            do {
                if !database.executeStatements(query) {
                    print("Failed to insert initial data into the database.")
                    print(database.lastError(), database.lastErrorMessage())
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
    }
    
    
    
    
    
    /**
     Query Execution. It can used for fetching data from table
     
     @param  query : Statement for execution
     
     @return Boolean value - return data in  FMResultSet
     */

    func fetchData(Query : String) -> FMResultSet {
        let values = FMResultSet()
        if openDatabase() {
            do {
                print(database)
                let results = try database.executeQuery(Query, values: nil)
                return results;
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return values
    }
    
    
   
    
    /**
     Query Execution. It can used for fetching data from table
     
     @param  query : Statement for execution
     
     @return Boolean value - return data in  FMResultSet
     */
    
    func fetchDataDic(Query : String) -> FMResultSet {
        
        var dic = NSDictionary()
        
        let values = FMResultSet()
        if openDatabase() {
            do {
                print(database)
                let results = try database.executeQuery(Query, values: nil)
                 print(results)
                dic=results.resultDictionary() as! NSDictionary;
                print(dic)
                return results;
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return values
    }
    
 
    
    /**
     Query Execution. It can used for fetching data from table with call back function
     
     @param  query : Statement for execution
     
     @return Boolean value - return data in  FMResultSet
     */
    
    func fetchData(withQuery query: String, completionHandler: (_ response: FMResultSet?) -> Void) {
        
        let values = FMResultSet()
        if openDatabase() {
           do {
                let results = try database.executeQuery(query, values: nil)
            
                completionHandler(results)
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        completionHandler(values)
    }
    
   
    
  }
