package com.itsmemayday.todolist.controller;

import com.itsmemayday.todolist.model.Todo;
import com.itsmemayday.todolist.repository.TodoRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/todos")
public class TodoController {
    private final TodoRepository repo;
    public TodoController(TodoRepository repo) { this.repo = repo; }

    @GetMapping
    public List<Todo> all() { return repo.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Todo> one(@PathVariable Long id) {
        return repo.findById(id).map(ResponseEntity::ok)
                   .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Todo create(@RequestBody Todo todo) { return repo.save(todo); }

    @PutMapping("/{id}")
    public ResponseEntity<Todo> update(@PathVariable Long id, @RequestBody Todo incoming) {
        return repo.findById(id)
            .map(existing -> {
                existing.setTitle(incoming.getTitle());
                existing.setCompleted(incoming.isCompleted());
                return ResponseEntity.ok(repo.save(existing));
            })
            .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (!repo.existsById(id)) return ResponseEntity.notFound().build();
        repo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}