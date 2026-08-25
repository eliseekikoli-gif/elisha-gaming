package com.elishatools.app.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun SettingsScreen() {
    var recordAudio by remember { mutableStateOf(true) }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text("Paramètres", style = MaterialTheme.typography.headlineMedium)
        Spacer(Modifier.height(16.dp))
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text("Audio du microphone")
            Switch(checked = recordAudio, onCheckedChange = { recordAudio = it })
        }
        HorizontalDivider(Modifier.padding(vertical = 8.dp))
        Text("À propos", style = MaterialTheme.typography.titleMedium)
        Spacer(Modifier.height(4.dp))
        Text("Eli Sha Tools v1.0\nConçu pour les créateurs de contenu.", color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
}
