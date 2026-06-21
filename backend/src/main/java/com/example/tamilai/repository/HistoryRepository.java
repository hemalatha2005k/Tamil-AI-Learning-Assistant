package com.example.tamilai.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.tamilai.entity.History;
import com.example.tamilai.entity.User;

@Repository
public interface HistoryRepository extends JpaRepository<History, Long> {

    List<History> findByUserOrderByCreatedAtDesc(User user);

    List<History> findByUserAndSavedTrueOrderByCreatedAtDesc(User user);
}