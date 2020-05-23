package com.myorg;

import software.amazon.awscdk.core.App;

public class MyEcsConstructApp {
    public static void main(final String[] args) {
        App app = new App();

        new MyEcsConstructStack(app, "MyEcsConstructStack");

        app.synth();
    }
}
