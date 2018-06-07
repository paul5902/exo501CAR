package fr.eservices.drive.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import fr.eservices.drive.dao.OrderDao;
import fr.eservices.drive.model.Order;

@Repository
public interface OrderRepository extends OrderDao, CrudRepository<Order, Long> {

	public List<Order> findByCustomerIdOrderByCreatedOnDesc(String customerId);
}
