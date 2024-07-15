package com.example.my_demo_app_flutter;

import androidx.test.rule.ActivityTestRule;
import dev.flutter.plugins.integration_test.FlutterTestRunner;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;


@RunWith(FlutterTestRunner.class)
public class MainActivityTest {
    @Rule
    public ActivityTestRule<MainActivity> rule = new ActivityTestRule<>(MainActivity.class, true, false);

    @Test
    public void test_test_test_test(){
        System.out.println("Test the Test");
    }
}