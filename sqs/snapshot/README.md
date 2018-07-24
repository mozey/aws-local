Create a snapshot of all messages in queue `local-queue-snapshot`.
Messages are added to the snapshot in the order received from the queue.
The first message received will be the first array element 
in the file named with the oldest timestamp 

    go run snapshot.go -create ./local-queue-snapshot
    
Load a snapshot of a queue,
use the optional fifo flag to add messages ordered by snapshot file timestamp

    go run snapshot.go -load ./local-queue-snapshot -fifo
    
