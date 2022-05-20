import 'package:exye_app/Data/timeslot.dart';
import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_footer.dart';
import 'package:exye_app/Widgets/custom_header.dart';
import 'package:exye_app/Widgets/custom_textbox.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';

class CustomCalendar extends StatefulWidget {
  final Function back;
  final Function finish;
  final int type;
  final int? oldSlot;
  final PageController control;
  const CustomCalendar({required this.back, required this.finish, required this.type, this.oldSlot, required this.control, Key? key}) : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  Timeslot? date;
  int slot = 0;

  void next () {
    widget.control.animateToPage(1, duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void prev () {
    widget.control.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  @override
  void initState () {
    super.initState();
    if (widget.oldSlot != null) {
      date = app.mData.calendar!.current!.days[app.mData.user!.order!.day - 1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width - 20,
      width: MediaQuery.of(context).size.width,
      child: PageView(
        controller: widget.control,
        physics: const NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          buildDatePicker(),
          buildSlotPicker(),
        ],
      ),
    );
  }

  Widget buildDatePicker () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomHeader(app.mResource.strings.hCalendar1),
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text(
              (date == null) ? DateTime.now().month.toString() + app.mResource.strings.cMonth + " " + DateTime.now().day.toString() + app.mResource.strings.cDay + " " + app.mResource.strings.weekdays[DateTime.now().weekday % 7] : date!.month.toString() + app.mResource.strings.cMonth + " " + date!.day.toString() + app.mResource.strings.cDay + " " + app.mResource.strings.weekdays[date!.weekday],
              style: app.mResource.fonts.headerLight,
            ),
        ),
        Container(
          height: 10,
        ),
        CustomBox(
          height: MediaQuery.of(context).size.width - 50,
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 32,
                width: MediaQuery.of(context).size.width - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageButton(
                      image: app.mResource.images.bPrev,
                      height: 32,
                      width: 32,
                      thickness: 1,
                      function: () async {
                        await app.mData.getCalendarData(app.mData.calendar!.prev!.year, app.mData.calendar!.prev!.month);
                        setState(()  {});
                        print(date!.year);
                      },
                      colourPressed: app.mResource.colours.buttonLight,
                      colourUnpressed: app.mResource.colours.buttonLight,
                    ),
                    Container(
                      width: 10,
                    ),
                    Text(app.mData.calendar?.current?.month.toString() ?? "" + app.mResource.strings.cMonth, style: app.mResource.fonts.header,),
                    Container(
                      width: 10,
                    ),
                    CustomImageButton(
                      image: app.mResource.images.bNext,
                      height: 32,
                      width: 32,
                      thickness: 1,
                      function: () async {
                        await app.mData.getCalendarData(app.mData.calendar!.next!.year, app.mData.calendar!.next!.month);
                        setState(() {});
                      },
                      colourPressed: app.mResource.colours.buttonLight,
                      colourUnpressed: app.mResource.colours.buttonLight,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: buildGrid(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
        CustomFooter(
          button1: CustomHybridButton(
            image: app.mResource.images.bPrev,
            text: app.mResource.strings.bPrev,
            style: app.mResource.fonts.bold16,
            height: 50,
            function: () {
              setState(() {
                widget.back();
              });
            },
            colourUnpressed: app.mResource.colours.buttonLight,
            colourPressed: app.mResource.colours.buttonLight,
          ),
          button2: CustomHybridButton2(
            image: app.mResource.images.bNextWhite,
            text: app.mResource.strings.bNext,
            style: app.mResource.fonts.bWhite16,
            height: 50,
            function: () {
              if (date == null) {
                app.mApp.buildAlertDialog(context, header: app.mResource.strings.aNoDate, text: app.mResource.strings.eNoDate);
              }
              else {
                if (widget.oldSlot != null) {
                  if ((app.mData.user!.order!.year == date!.year) && (app.mData.user!.order!.month == date!.month) && (app.mData.user!.order!.day == date!.day)) {
                    slot = widget.oldSlot ?? 0;
                  }
                }
                setState(() {
                  next();
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildSlotPicker () {
    return Column(
      children: [
        CustomHeader(app.mResource.strings.hCalendar2),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          alignment: Alignment.centerLeft,
          child: Text(
            (date == null) ? app.mResource.strings.pChooseDate : date!.month.toString() + app.mResource.strings.cMonth + " " + date!.day.toString() + app.mResource.strings.cDay + " " + app.mResource.strings.weekdays[date!.weekday] + " " + ((slot == 0) ? "" : (" " + slot.toString() + ":00" + app.mResource.strings.cTime)),
            style: app.mResource.fonts.headerLight,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            alignment: Alignment.topCenter,
            child: CustomBox(
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 2,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                itemBuilder: (context, index) {
                  bool? inactive;
                  DateTime now = DateTime.now();
                  if (now.hour > 20 && now.add(const Duration(days: 1)).isAfter(DateTime(date!.year, date!.month, date!.day))) {
                    inactive = false;
                  }
                  return CustomTimeslotButton(
                    text: (index + 11).toString() + ":00",
                    height: 32,
                    width: 58,
                    function: () {
                      setState(() {
                        slot = index + 11;
                      });
                    },
                    active: inactive ?? (date!.slots![index + 1] == "" || date!.slots![index + 1] == app.mData.user!.id),
                    slot: index + 11,
                    chosen: slot,
                  );
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(),
        ),
        CustomFooterToHome(
          button1: CustomHybridButton(
            image: app.mResource.images.bPrev,
            text: app.mResource.strings.bPrev,
            style: app.mResource.fonts.bold16,
            height: 50,
            function: () {
              setState(() {
                slot = 0;
                prev();
              });
            },
            colourUnpressed: app.mResource.colours.buttonLight,
            colourPressed: app.mResource.colours.buttonLight,
          ),
          button2: CustomHybridButton2(
            image: app.mResource.images.bNextWhite,
            text: app.mResource.strings.bNext,
            style: app.mResource.fonts.bWhite16,
            height: 50,
            function: () async {
              if (slot == 0) {
                app.mApp.buildAlertDialog(context, header: app.mResource.strings.aNoTime, text: app.mResource.strings.eNoTime);
              }
              else {
                widget.finish(date, slot);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildGrid () {
    int dayOneIndex = (app.mData.calendar?.current?.days[0].weekday ?? 1) - 1;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemCount: 42,
      itemBuilder: (BuildContext context, int index) {
        if (index < 7) {
          return Align(
            alignment: Alignment.center,
            child: Text(app.mResource.strings.weekdaysShort[index], style: app.mResource.fonts.bold,),
          );
        }
        if ((index - 7) <= dayOneIndex) {
          return Container();
        }
        if ((index - 7) > dayOneIndex + (app.mData.calendar?.current?.days.length ?? 30)) {
          return Container();
        }
        return CustomCalendarButton(
          height: 40,//(MediaQuery.of(context).size.width - 120) / 7,
          width: 40,//(MediaQuery.of(context).size.width - 120) / 7,
          function: () {
            setState(() {
              date = app.mData.calendar!.current!.days[(index - 7) - dayOneIndex - 1];
              slot = 0;
            });
          },
          date: app.mData.calendar!.current!.days[(index - 7) - dayOneIndex - 1],
          chosen: date,
          type: widget.type,
        );
      },
    );
  }
}

class CustomCalendarButton extends StatefulWidget {
  final Timeslot date;
  final Timeslot? chosen;
  final Function function;
  final double height;
  final double width;
  final int type;
  const CustomCalendarButton({required this.function, required this.date, required this.chosen, required this.height, required this.width, required this.type, Key? key}) : super(key: key);

  @override
  _CustomCalendarButtonState createState() => _CustomCalendarButtonState();
}

class _CustomCalendarButtonState extends State<CustomCalendarButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.date.isValid(widget.type) > 0){
          widget.function();
        }
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: widget.height,
          width: widget.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: (widget.date.isValid(widget.type) < 1) ? null : Border.all(width: 1, color: app.mResource.colours.black),
            color: (widget.date.isValid(widget.type) < 1) ? app.mResource.colours.transparent : ((widget.date.isSame(widget.chosen)) ? app.mResource.colours.black : app.mResource.colours.greyBackground),
          ),
          child: Text(
            widget.date.day.toString(),
            style: (widget.date.isValid(widget.type) < 1) ? (widget.date.isValid(widget.type) == -1 ? app.mResource.fonts.calendarToday : app.mResource.fonts.calendarInactive) : ((widget.date.isSame(widget.chosen)) ? app.mResource.fonts.calendarWhite : app.mResource.fonts.calendarBold),
          ),
        ),
      ),
    );
  }
}

class CustomTimeslotButton extends StatefulWidget {
  final String text;
  final double height;
  final double width;
  final Function function;
  final bool active;
  final int slot;
  final int chosen;
  const CustomTimeslotButton({required this.text, required this.height, required this.width, required this.function, required this.active, required this.slot, required this.chosen, Key? key}) : super(key: key);

  @override
  _CustomTimeslotButtonState createState() => _CustomTimeslotButtonState();
}

class _CustomTimeslotButtonState extends State<CustomTimeslotButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.function();
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: widget.height,
          width: widget.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: !(widget.active) ? null : Border.all(width: 1, color: app.mResource.colours.black),
            color: !(widget.active) ? app.mResource.colours.transparent : ((widget.slot == widget.chosen) ? app.mResource.colours.black : app.mResource.colours.greyBackground),
          ),
          child: Text(
            widget.text,
            style: !(widget.active) ? app.mResource.fonts.inactive : ((widget.slot == widget.chosen) ? app.mResource.fonts.calendarWhite : app.mResource.fonts.calendarBold),
          ),
        ),
      ),
    );
  }
}




