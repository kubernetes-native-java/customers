package com.example.customers;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.condition.ConditionalOnCloudPlatform;
import org.springframework.boot.availability.AvailabilityChangeEvent;
import org.springframework.boot.availability.LivenessState;
import org.springframework.boot.cloud.CloudPlatform;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import reactor.core.publisher.Flux;

@Log4j2
@SpringBootApplication
public class CustomersApplication {

	@Bean
	@ConditionalOnCloudPlatform(CloudPlatform.KUBERNETES)
	ApplicationRunner k8sRunner() {
		return args -> log.info("hello, Kubernetes!");
	}

	public static void main(String[] args) {
		SpringApplication.run(CustomersApplication.class, args);
	}
}

@Log4j2
@ResponseBody
@Controller
@RequiredArgsConstructor
class HealthController {

	private final ApplicationContext applicationContext;

	@PostMapping("/down")
	void down() {
		AvailabilityChangeEvent.publish(this.applicationContext, LivenessState.BROKEN);
		log.info("setting " + LivenessState.class.getName() + " to " + LivenessState.BROKEN);
	}
}


@ResponseBody
@Controller
@RequiredArgsConstructor
class CustomerRestController {

	private final CustomerRepository repository;

	@GetMapping("/customers")
	Flux<Customer> customers() {
		return this.repository.findAll();
	}
}

interface CustomerRepository extends ReactiveCrudRepository<Customer, Integer> {
}

@Data
@AllArgsConstructor
@NoArgsConstructor
class Customer {
	private Integer id;
	private String name;
}
