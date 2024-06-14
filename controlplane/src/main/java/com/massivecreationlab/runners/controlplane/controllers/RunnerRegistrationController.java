package com.massivecreationlab.runners.controlplane.controllers;

import com.massivecreationlab.runners.controlplane.dtos.RunnerRegistrationResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@RestController
public class RunnerRegistrationController {

    @Value("${github.token}")
    private String githubToken;

    @Value("${github.organization}")
    private String githubOrganization;

    private final WebClient webClient;

    public RunnerRegistrationController(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.baseUrl("https://api.github.com").build();
    }
    
    @PostMapping("/register")
    public Mono<RunnerRegistrationResponse> Register(){
        return webClient.post()
                .uri("/orgs/" + githubOrganization + "/actions/runners/registration-token")
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + githubToken)
                .accept(MediaType.APPLICATION_JSON)
                .retrieve()
                .bodyToMono(RunnerRegistrationResponse.class);
    }
}
