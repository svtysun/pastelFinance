import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    // Atur buildDir untuk masing-masing subproject
    val newSubprojectBuildDir: Directory = newBuildDir.dir(name)
    layout.buildDirectory.set(newSubprojectBuildDir)

    // Pastikan semua subproject menunggu evaluasi project ":app" (jika perlu)
    evaluationDependsOn(":app")
}

// Task clean untuk membersihkan build folder kustom
tasks.register<Delete>("clean") {
    delete(rootProject

