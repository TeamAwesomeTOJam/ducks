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
    while tail:
        tail = tail.next
        length += 1
        
        
func splt_at_node(node):
    var _length = 0
    _node = head
    while _node != node:
        _node = _node.next
        _length += 1
    
    length = _length
        
    if _node:
        if _node.prev:
            _node.prev.next = null
        _node.prev = null
        
        
func apply_function_to_nodes(function):
    var _node = head
    while _node:
        function(_node)