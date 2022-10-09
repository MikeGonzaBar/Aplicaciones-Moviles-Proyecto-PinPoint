List<dynamic> postsList = [
  {
    "authorId": "user1",
    "post": {
      "postId": "post1",
      "text": "Vi a Spiderman pasar por el D. No más robos de carros 🕷",
      "image": "",
      "anonymous": true,
      "latitude": 20.60990223955398,
      "longitude": -103.41462537882695,
      "timestamp": DateTime.now(),
      "comments": [
        "comment2",
        "comment3",
        "comment4",
        "comment5",
        "comment6",
        "comment7",
        "comment8",
        "comment9",
        "comment10",
        "comment11",
        "comment12"
      ],
      "userUpVotes": [
        "user1",
        "user6",
        "user3",
        "user4",
        "user5",
      ],
      "userDownVotes": ["user2"]
    },
  },
  {
    "authorId": "user1",
    "post": {
      "postId": "post2",
      "text": "Vendo stickers en el tianguis del ombligo :)",
      "image": "assets/images/gatosIteso.png",
      "anonymous": false,
      "latitude": 20.605014767747804,
      "longitude": -103.41542611560448,
      "timestamp": DateTime.now(),
      "comments": ["comment1"],
      "userUpVotes": [
        "user1",
        "user6",
        "user3",
        "user4",
        "user5",
      ],
      "userDownVotes": ["user2"]
    },
  },
  {
    "authorId": "user2",
    "post": {
      "postId": "post3",
      "text": "Extrañaba los jardines de ITESO. De plano hice un picnic",
      "image": "",
      "anonymous": false,
      "latitude": 20.60990223955398,
      "longitude": -103.41462537882695,
      "timestamp": DateTime.now(),
      "comments": ["comment13, comment14, comment15"],
      "userUpVotes": [
        "user1",
        "user6",
        "user3",
        "user4",
        "user5",
      ],
      "userDownVotes": ["user2"]
    },
  },
];

List<dynamic> comments = [
  {
    "authorId": "user1",
    "postId": "post2",
    "commentId": "comment1",
    "comment": "Yo quierooo. Iré a las 11",
    "votes": 2
  }
];

List<dynamic> usersList = [
  {
    "authorId": "1",
    "data": {
      "username": "Martha Y",
      "creation_date": "2022-08-10",
      "qtty_likes": 75,
    },
  },
  {
    "authorId": "2",
    "data": {
      "username": "Ale E",
      "creation_date": "2022-08-5",
      "qtty_likes": 32,
    },
  }
];
