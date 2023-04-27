
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folderdocker/main.dart';
import 'package:folderdocker/screens/transferenciawid.dart';

class AnimatedTabBar extends StatefulWidget {
  const AnimatedTabBar({required this.tabs});

  final List<Widget> tabs;

  @override
  _AnimatedTabBarState createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  late AnimationController _animationController;
  late Animation<double> _lineScaleAnimation;
  late int _previousTabIndex;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _previousTabIndex = _tabController.index;

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _lineScaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      _previousTabIndex = _tabController.previousIndex;
    });

    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: widget.tabs,
        ),
        SizedBox(
          height: 2.0,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 2.0,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor,
                      ),
                      value: _lineScaleAnimation.value,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 2.0,
                    child: FractionallySizedBox(
                      widthFactor: 1 / widget.tabs.length,
                      child: Align(
                        alignment: _tabController.animation != null &&
                                _tabController.animation!.value != null
                            ? Alignment.lerp(
                                  Alignment.centerLeft,
                                  Alignment.centerRight,
                                  _tabController.animation!.value,
                                ) ??
                                Alignment.centerLeft
                            : Alignment.centerLeft,
                        child: SizedBox(
                          height: 2.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
main() {
  runApp(MaterialApp(
    home: hola(),
  ));
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3, // Número de pestañas
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Pestaña 1'),

                Tab(text: 'Pestaña 2'),
                Tab(text: 'Pestaña 3'),
              ],
            ),
            title: Text('Ejemplo de pestañas en Flutter'),
          ),
          body: TabBarView(
            children: [
              // Contenido de la pestaña 1
              Center(
                child: Text('Contenido de la pestaña 1'),
              ),

              // Contenido de la pestaña 2
              Center(
                child: Text('Contenido de la pestaña 2'),

              ),
                TransferenciaWidget(),
              // Contenido de la pestaña 3
              Center(
                child: Text('Contenido de la pestaña 3'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
