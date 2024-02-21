package com.efrei.st2dce;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/")
public class MyController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @GetMapping
    public String getGreetings() {
        logger.debug("GET / is running successfully.");
        return "Hello, from ADXA (Antoine, Daniel, Xing, Aliaa) for Devops and Continuous Deployment final project for testing purposes.";
    }
}
