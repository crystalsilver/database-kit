import Async

/// Types conforming to this protocol can be used
/// as a database connection for executing queries.
public protocol DatabaseConnection: DatabaseConnectable {
    /// Closes the database connection when finished.
    func close()
}


extension DatabaseConnection {
    /// See `DatabaseConnectable.connect(to:)`
    public func connect<D>(to database: DatabaseIdentifier<D>?, on worker: Worker) -> Future<D.Connection> {
        return Future.map(on: worker) {
            guard let conn = self as? D.Connection else {
                throw DatabaseKitError(
                    identifier: "connectable",
                    reason: "Unexpected \(#function): \(self) not \(D.Connection.self)",
                    source: .capture()
                )
            }
            return conn
        }
    }
}
