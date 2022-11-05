class TasksDataModel
{
   String? image;
   String? title;
   String? description;
   String? date;
   String? time;
   TasksDataModel({this.image,this.title,this.description,this.date,this.time});
}

List<TasksDataModel> tasksData = [
  TasksDataModel(image: "",title: "Meetings",description: "Meeting with client and project manager",date: "26",time: "10:00 am - 12:00 am"),
  TasksDataModel(image: "",title: "Design",description: "UI design",date: "27",time: "11:00 am - 01:00 pm"),
  TasksDataModel(image: "",title: "Calls",description: "Client calls",date: "25",time: "09:00 am - 11:00 am"),
  TasksDataModel(image: "",title: "Review",description: "Code review",date: "28",time: "08:00 am - 10:00 am"),
  TasksDataModel(image: "",title: "Project Sprint 2 Discussion",description: "Sprint task Discussion",date: "29",time: "11:00 am - 01:00 pm"),
  TasksDataModel(image: "",title: "Project Sprint 3 Discussion",description: "Sprint task Discussion",date: "30",time: "10:00 am - 12:00 am"),
  TasksDataModel(image: "",title: "Project Sprint 1 Discussion",description: "Sprint task Discussion",date: "15",time: "09:00 am - 11:00 am"),
  TasksDataModel(image: "",title: "UI Enhancement",description: "New changes",date: "11",time: "08:00 am - 10:00 am"),
  TasksDataModel(image: "",title: "Demo preparation",description: "Project prototype",date: "22",time: "10:00 am - 12:00 am"),
  TasksDataModel(image: "",title: "Presentation",description: "Presentation",date: "22",time: "11:00 am - 01:00 pm"),
];