import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/pages/Achievements.dart';
import 'package:flutter_application_1/pages/Announcements.dart';
import 'package:flutter_application_1/pages/Community/Community.dart';
import 'package:flutter_application_1/pages/Events.dart';
import 'package:flutter_application_1/pages/Images.dart';
import 'package:flutter_application_1/pages/Studymaterial.dart';
import 'package:flutter_application_1/pages/UpcomingEvents.dart';
import 'package:flutter_application_1/pages/developer.dart';
import 'package:flutter_application_1/pages/placement.dart';
import 'package:flutter_application_1/pages/teachers.dart';
import 'package:flutter_application_1/pages/team.dart';
import 'package:flutter_application_1/pages/videos.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> carouselImages = [];

  final CollectionReference _carouselImagesCollection =
      FirebaseFirestore.instance.collection('carousel_images');

  @override
  void initState() {
    super.initState();
    fetchCarouselImages();
  }

  void fetchCarouselImages() async {
    try {
      QuerySnapshot querySnapshot = await _carouselImagesCollection.get();
      List<String> imageUrls =
          querySnapshot.docs.map((doc) => doc['Curl'].toString()).toList();

      setState(() {
        carouselImages = imageUrls;
      });
    } catch (e) {
      print('Error fetching carousel images: $e');
    }
  }

  final List<GridItem> gridItems = [
    GridItem("Supporting Faculties", "assets/teachers.png", () => Teachers()),
    GridItem('Team Members', 'assets/image_team.png', () => TeamMembersPage()),
    GridItem('Events', 'assets/events.png', () => EventsPage()),
    GridItem(
        'Achievements', 'assets/acheivement.png', () => AchievementsPage()),
    GridItem('Upcoming Events', 'assets/next.png', () => UpcomingEventsPage()),
    GridItem("Event Images", "assets/background_images.png", () => Images()),
    GridItem("Video Tutorials", "assets/video.png", () => Videos()),
    GridItem("Department Community", "assets/Commity.jpg", () => Community()),
    GridItem("Announcements", "assets/announcement.jpg", () => Announcements()),
    GridItem("Placement Info", "assets/placement.jpeg", () => Placement()),
    GridItem(
        "Study material", "assets/Studymaterial.jpeg", () => StudyMaterial()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 95, 214),
        title: const Text(
          'Embedded Club Home',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_home.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                CarouselSlider(
                  items: carouselImages.map((imagePath) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.9,
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: gridItems.length,
                    itemBuilder: (context, index) {
                      return GridTile(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => gridItems[index].page(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(gridItems[index].imagePath),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      gridItems[index].title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Developer()));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10)),
                      height: 40,
                      width: double.infinity,
                      child: const Text(
                        "Click for Developer's Info",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridItem {
  final String title;
  final String imagePath;
  final Widget Function() page;

  GridItem(this.title, this.imagePath, this.page);
}
