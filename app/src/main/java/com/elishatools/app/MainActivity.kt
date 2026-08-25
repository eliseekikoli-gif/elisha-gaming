package com.elishatools.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Alarm
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.Share
import androidx.compose.material.icons.filled.Videocam
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.elishatools.app.ui.screens.*
import com.elishatools.app.ui.theme.EliShaToolsTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            EliShaToolsTheme {
                val navController = rememberNavController()
                Scaffold(
                    bottomBar = {
                        NavigationBar(containerColor = MaterialTheme.colorScheme.surface) {
                            NavigationBarItem(
                                selected = false,
                                onClick = { navController.navigate("home") },
                                icon = { Icon(Icons.Default.Home, contentDescription = "Accueil") },
                                label = { Text("Accueil") }
                            )
                            NavigationBarItem(
                                selected = false,
                                onClick = { navController.navigate("whatsapp") },
                                icon = { Icon(Icons.Default.Share, contentDescription = "Statuts") },
                                label = { Text("Statuts") }
                            )
                            NavigationBarItem(
                                selected = false,
                                onClick = { navController.navigate("recorder") },
                                icon = { Icon(Icons.Default.Videocam, contentDescription = "Capture") },
                                label = { Text("Écran") }
                            )
                            NavigationBarItem(
                                selected = false,
                                onClick = { navController.navigate("alarms") },
                                icon = { Icon(Icons.Default.Alarm, contentDescription = "Alarmes") },
                                label = { Text("Rappels") }
                            )
                        }
                    }
                ) { padding ->
                    NavHost(
                        navController = navController,
                        startDestination = "home",
                        modifier = Modifier.padding(padding)
                    ) {
                        composable("home") { HomeScreen(navController) }
                        composable("whatsapp") { WhatsAppStatusScreen() }
                        composable("recorder") { ScreenRecorderScreen() }
                        composable("alarms") { AlarmScreen() }
                        composable("settings") { SettingsScreen() }
                    }
                }
            }
        }
    }
}
