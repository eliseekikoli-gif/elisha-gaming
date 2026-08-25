package com.elishatools.app.ui.screens

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.media.projection.MediaProjectionManager
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import com.elishatools.app.services.ScreenRecordService

@Composable
fun ScreenRecorderScreen() {
    val context = LocalContext.current
    var isRecording by remember { mutableStateOf(false) }

    val projectionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.StartActivityForResult()
    ) { result ->
        if (result.resultCode == Activity.RESULT_OK && result.data != null) {
            val intent = Intent(context, ScreenRecordService::class.java).apply {
                putExtra("RESULT_CODE", result.resultCode)
                putExtra("DATA", result.data)
            }
            context.startForegroundService(intent)
            isRecording = true
        }
    }

    Column(
        modifier = Modifier.fillMaxSize().padding(16.dp),
        horizontalAlignment = Alignment.CenterVertically,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = if (isRecording) "Enregistrement en cours..." else "Prêt à enregistrer",
            style = MaterialTheme.typography.titleLarge
        )
        Spacer(Modifier.height(24.dp))
        Button(
            colors = ButtonDefaults.buttonColors(
                containerColor = if (isRecording) MaterialTheme.colorScheme.error else MaterialTheme.colorScheme.primary
            ),
            onClick = {
                if (!isRecording) {
                    val manager = context.getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
                    projectionLauncher.launch(manager.createScreenCaptureIntent())
                } else {
                    context.stopService(Intent(context, ScreenRecordService::class.java))
                    isRecording = false
                }
            }
        ) {
            Text(if (isRecording) "Arrêter l'enregistrement" else "Démarrer la capture")
        }
    }
}
