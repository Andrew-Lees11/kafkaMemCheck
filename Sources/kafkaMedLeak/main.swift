import SwiftKafka
import Foundation

var i = 0
var produced = 0
var consumed = 0

 do {
    let config = KafkaConfig()
    config.groupId = "Kitura"
    config.autoOffsetReset = .beginning
    config.brokerAddressFamily = .v4
    let consumer = try KafkaConsumer(config: config)
    guard consumer.connect(brokers: "localhost:9092") == 1 else {
        throw KafkaError(rawValue: 8)
    }
    try consumer.subscribe(topics: ["test"])
    while(true) {
        let config = KafkaConfig()
        config.brokerAddressFamily = .v4
        let producer = try KafkaProducer(config: config)
        guard producer.connect(brokers: "localhost:9092") == 1 else {
            throw KafkaError(rawValue: 8)
        }
        for j in 0..<5000 {
            producer.send(producerRecord: KafkaProducerRecord(topic: "test", value: "Record: \(i), \(j)")) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        print("Error producing: \(error)")
                    }
                }
            produced += 1
        }       
        //for _ in 0...5 {
        let records = try consumer.poll(timeout: 0.1)
            consumed += records.count
        //}
        if i % 10 == 0 {
            print("produced: \(produced), consumed: \(consumed)")
        }
        i += 1
    }
 } catch {
    print("Error creating consumer: \(error)")
}
