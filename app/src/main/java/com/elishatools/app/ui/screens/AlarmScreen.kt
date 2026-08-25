package com.elishatools.app.ui.screens

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AddAlert
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import com.elishatools.app.services.AlarmReceiver

@Composable
fun AlarmScreen() {
    val context = LocalContext.current
    var title by remember { mutableStateOf("") }
    var minutesFromNow by remember { mutableStateOf("5") }

    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text("Créer un rappel", style = MaterialTheme.typography.titleLarge)
        Spacer(Modifier.height(16.dp))
        OutlinedTextField(
            value = title,
            onValueChange = { title = it },
            label = { Text("Titre de l'alarme") },
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(Modifier.height(8.dp))
        OutlinedTextField(
            value = minutesFromNow,
            onValueChange = { minutesFromNow = it },
            label = { Text("Déclencher dans (minutes)") },
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(Modifier.height(16.dp))
        Button(
            onClick = {
                val delay = (minutesFromNow.toLongOrNull() ?: 1) * 60 * 1000
                val alarmTime = System.currentTimeMillis() + delay

                val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                val intent = Intent(context, AlarmReceiver::class.java).apply {
                    putExtra("TITLE", title.ifBlank { "Rappel Eli Sha Tools" })
                }
                val pendingIntent = PendingIntent.getBroadcast(
                    context, 0, intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

                alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, alarmTime, pendingIntent)
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Icon(Icons.Default.AddAlert, contentDescription = null)
            Spacer(Modifier.width(8.dp))
            Text("Programmer le rappel")
        }
    }
}
