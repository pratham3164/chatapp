const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
    .document('chat/{messages}')
    .onCreate((snapShot, context) => {
        return admin.messaging().sendToTopic('chat', {
            notification: {
                title: snapShot.data().username,
                body: snapShot.data().text,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        })
    });
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
