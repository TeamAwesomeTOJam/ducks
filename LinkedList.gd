extends Node

var head = null
var tail = null
var length = 0


func add_nodes_tail(node):
    if tail: 
        tail.next = node
        node.prev = tail
    else:
        head = node
    
    tail = node
    length += 1
    while tail.next:
        tail = tail.next
        length += 1
        
    print(head)
    print(tail)
        
        
func split_at_node(node):
    var _length = 0
    var _node = head
    while _node != null && _node != node:
        _node = _node.next
        _length += 1
        
    if _node:
        if _node.prev:
            _node.prev.next = null
        tail = _node.prev
        _node.prev = null
        
        length = _length
        if length < 1:
            head = tail
        