console.log('Server-side code running');

const express = require('express');
const MongoClient = require('mongodb').MongoClient;
const app = express();
var nodemailer = require('nodemailer');
var distance = require('google-distance');
distance.apiKey = 'AIzaSyBl_MwSYokMdYuIQq6PPAoVgJFMdelLF0k';
// serve files from the public directory
app.use(express.static('public'));

var bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// connect to the db and start the express server
let db;
// var username;

// ***Replace the URL below with the URL for your database***
const url = 'mongodb://ThaparUser:Pass#123@ds241537.mlab.com:41537/hospital';
// E.g. for option 2) above this will be:
// const url =  'mongodb://localhost:21017/databaseName';

MongoClient.connect(url, (err, database) => {
    if (err) {
        return console.log(err);
    }
    db = database;
    // start the express web server listening on 8080
    app.listen(8080, () => {
        console.log('listening on 8080');
    });
});


app.get('/medicinessearch', (req, res) => {
    db.collection('medicines').find({}).toArray((err, result) => {
        if (err) {
            res.send(err);
        }
        else {
            res.send(result);
        }
    })
});

app.get('/medicalstoredetails', (req, res) => {
    db.collection('hospitaldetailes').find({}).toArray((err, result) => {
        if (err) {
            res.send(err);
        }
        else {
            res.send(result);
        }
    })
});


app.post('/decreasestock', (req, res) => {
    console.log(req.body);
    var decreasestock = req.body;
    var stockcount;
    db.collection('medicines').find({ hospitalname: decreasestock.hospitalname, medicinename: decreasestock.medicine }).toArray((err, result) => {
        if (err) {
            res.send(err);
        }
        else {
            if (result.length > 0) {
                var myquery = { hospitalname: decreasestock.hospitalname, medicinename: decreasestock.medicine };
                var newvalues = { $set: { stock: (parseInt(result[0].stock) - parseInt(decreasestock.count)).toString() } };
                db.collection('medicines').updateOne(myquery, newvalues, (err, result) => {
                    if (err) {
                        return console.log(err);
                    }
                    console.log('click added to db');
                    res.sendStatus(201);
                });

            }

        }
    })
});

app.post('/increasestock', (req, res) => {
    console.log(req.body);
    var increasestock = req.body;
    var stockcount;
    db.collection('medicines').find({ hospitalname: increasestock.hospitalname, medicinename: increasestock.medicine }).toArray((err, result) => {
        if (err) {
            res.send(err);
        }
        else {
            if (result.length > 0) {
                var myquery = { hospitalname: increasestock.hospitalname, medicinename: increasestock.medicine };
                var newvalues = { $set: { stock: (parseInt(result[0].stock) + parseInt(increasestock.count)).toString() } };
                db.collection('medicines').updateOne(myquery, newvalues, (err, result) => {
                    if (err) {
                        return console.log(err);
                    }
                    console.log('click added to db');
                    res.sendStatus(201);
                });

            }

        }
    })
});


app.get('/doctorsearch', (req, res) => {
    db.collection('doctorsdes').find({}).toArray((err, result) => {
        if (err) {
            res.send(err);
        }
        else {
            res.send(result);
        }
    })
});
let transporter = nodemailer.createTransport({
    service: 'gmail',
    secure: false,
    port: 25,
    auth: {
        user: 'GBM918211@gmail.com',
        pass: 'Pass#123!'
    },
    tls: {
        rejectUnauthorized: true
    }
});
app.post('/placeappointment', (req, res) => {
    console.log(req.body);
    var appointment = req.body;

    var lastappointmentnumber;

    var doctorappointmentDB = db.collection('doctorappointment');

    doctorappointmentDB.find().sort({ idno: -1, doctorname: -1, appointmentno: -1 }).limit(1).toArray((err, result) => {
        if (err) {
            res.send(err);
        }
        var count = 1;

        if (result.length > 0) {
            count = parseInt(result[0].appointmentno) + 1;
        }

        lastappointmentnumber = count.toString();

        var saveappointment = {
            doctorname: appointment.doctorname,
            idno: appointment.idno,
            patientname: appointment.patientname,
            appointmentno: lastappointmentnumber,
            problem: appointment.problem,
            timeslot: appointment.timeslot,
            contactno: appointment.contactno,
            patientemail: appointment.patientemail,
        };

        doctorappointmentDB.save(saveappointment, (err, result) => {
            if (err) {
                return console.log(err);
            }
            console.log('click added to db');

            let HelperOptions = {
                from: 'GBM918211@gmail.com',
                to: saveappointment.patientemail,
                subject: "Details anout your appointment",
                text: "Your appointment number for the timeslot " + saveappointment.timeslot + " is " + saveappointment.appointmentno + ". For further updates please check your email incase of any cancelation of appointment",

            };
            transporter.sendMail(HelperOptions, (error, info) => {
                if (error) {
                    console.log(error);
                }
                else {
                    console.log("message sent");
                }
            });

            res.sendStatus(201);
        });
    });
});
app.post('/sendlocation', (req, res) => {
    console.log(req.body);
    var location = req.body;
    var longitude;
    var latitude;
    var distancecalculated = 0;
    var distanceobtained;
    var hospitaldescription = db.collection('hospitaldetailes');

    hospitaldescription.find().sort({ latitude: 1, hospitalname: 1 }).toArray((err, result) => {
        if (err) {
            res.send(err);
        }
        var origin = location.latitude + "," + location.longitude;
        var destination = result[0].latitude + "," + result[0].longitude;
        distance.get(
            {
                origin: origin, // (parseInt(location.latitude), parseInt(location.longitude)),
                destination: destination // (parseInt(result[0].latitude), parseInt(result[0].longitude)),
            },
            function (err, data) {
                if (err) return console.log(err);
                console.log(data);
                distanceobtained = data.durationValue;

                result.forEach(element => {

                    origin = location.latitude + "," + location.longitude;
                    destination = element.latitude + "," + element.longitude;
            
                    distance.get(
                        {
                            origin: origin, // (parseInt(location.latitude), parseInt(location.longitude)),
                            destination: destination // (parseInt(element.latitude), parseInt(element.longitude)),
                        },
                        function (err, data) {
                            if (err) return console.log(err);
                            console.log(data);
                            distanceobtained = data.distanceValue;

                            if (distancecalculated <= distanceobtained) {
                                distancecalculated = distanceobtained;
                                latitude = element.latitude;
                                longitude = element.longitude;
                                hospitalname = element.hospitalname;
                            }

                        });
                });

                var today = new Date();
                var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
                time = time.toString;
                var alertamb = {
                    longitude: longitude,
                    latitude: latitude,
                    time: time,
                };

                db.collection('alertambulance').save(alertamb, (err, result) => {
                    if (err) {
                        return console.log(err);
                    }
                    console.log('click added to db');

                    res.sendStatus(201);

                });
            });

    });
});