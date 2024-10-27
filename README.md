<h2>Flutter Media Player</h2>
<p>This project demonstrates a robust media player app built with Flutter, featuring state management using <strong>BLoC</strong> for seamless handling of media playback states. The app supports both video and audio files, with the ability to play, pause, and stop media through dedicated controllers. Additionally, it leverages the <strong>Path Provider</strong> for data storage, <strong>Geocoder</strong> for location-based functionalities, and offers advanced control for managing multiple media files and alert functionality based on user location.</p>
Features
<ul> <li><strong>State Management:</strong> Implements BLoC for state handling.</li> <li><strong>Media Playback:</strong> <ul> <li>Video and audio playback via media libraries.</li> <li>Full controls to play, pause, and stop media files.</li> <li>Supports managing and switching between multiple media files.</li> </ul> </li> <li><strong>File Storage:</strong> Uses Path Provider for storing and retrieving files.</li> <li><strong>Location Handling:</strong> Geocoder integration to support location-based media alerts.</li> <li><strong>UI Elements:</strong> Full-screen video display with title and progress indicator.</li> </ul>
Quick Start
Prerequisites
Flutter SDK
Dart SDK
BLoC package for state management
Media player packages (video_player, audio_player)
Path Provider package
Geocoder package
Installation
<ol> <li>Clone the repository: <pre><code>git clone https://github.com/aadarshk7/videoplayer_app.git</code></pre> </li> <li>Navigate to the project directory: <pre><code>cd videoplayer_app</code></pre> </li> <li>Install dependencies: <pre><code>flutter pub get</code></pre> </li> <li>Run the application: <pre><code>flutter run</code></pre> </li> </ol>
Implementation Details
Media Playback Control
<p>This app supports the following features for each media file:</p> <ul> <li><strong>Play:</strong> Initiates the video or audio playback.</li> <li><strong>Pause:</strong> Pauses the current playback.</li> <li><strong>Stop:</strong> Stops playback entirely.</li> </ul>
Multi-Video Handling Task
The app includes a task sequence to demonstrate multi-video control:

<ol> <li><strong>Create a List of Videos:</strong> Load three videos from local storage.</li> <li><strong>Sequential Playback with Pauses:</strong> <ul> <li>Play the first video and pause after 15 seconds.</li> <li>Play the second video and pause after 20 seconds.</li> <li>Play the third video fully.</li> </ul> </li> <li><strong>Resume Playback:</strong> <ul> <li>Resume the second video after the third finishes.</li> <li>Resume the first video after the second finishes.</li> </ul> </li> </ol>
Location Alert Functionality
<p>To enhance user experience, a location-based alert feature is implemented:</p> <ol> <li><strong>Station Alert Videos:</strong> Create a list of stations with specific latitude and longitude.</li> <li><strong>Alert on Arrival:</strong> When the user approaches a station, the app pauses any current media and plays a station alert video.</li> <li><strong>Resume Playback:</strong> After the alert completes, the previously running media resumes.</li> </ol>
UI Overview
<p>The app features a minimalist UI:</p> <ul> <li><strong>Full-Screen Video Display:</strong> Provides an immersive experience.</li> <li><strong>Video Title:</strong> Displayed at the top.</li> <li><strong>Progress Indicator:</strong> Located at the bottom to track playback status.</li> </ul>
Dependencies
<ul> <li><strong>BLoC:</strong> State management solution.</li> <li><strong>video_player:</strong> For handling video playback.</li> <li><strong>audio_player:</strong> For handling audio playback.</li> <li><strong>path_provider:</strong> Manages storage data.</li> <li><strong>geocoder:</strong> Handles location services.</li> </ul>
Future Improvements
<ul> <li>Add more complex alert functionality.</li> <li>Expand media library compatibility.</li> <li>Improve UI with custom themes and controls.</li> </ul>
License
<p>This project is licensed under the MIT License.</p>
