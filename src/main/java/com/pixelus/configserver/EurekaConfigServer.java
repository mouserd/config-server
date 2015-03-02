package com.pixelus.configserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@ComponentScan
@Configuration
@EnableAutoConfiguration
@EnableEurekaServer
public class EurekaConfigServer {

    public static void main(final String[] args) {
        SpringApplication.run(EurekaConfigServer.class, args);
    }
}