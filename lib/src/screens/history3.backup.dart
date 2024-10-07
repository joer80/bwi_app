//Example of using an ExpansionTile to display a list of orders with line items. Line Items are hard coded.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async'; //optional but helps with debugging
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routing.dart';
import '../constants.dart'; //ie. var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
import '../auth.dart';
import 'package:intl/intl.dart'; //for number formatting

class HistoryScreen extends StatefulWidget {
  //final String jsonData;

  const HistoryScreen();

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  //Declare a list named data that will hold maps for each order.
  final List<Map<String, dynamic>> data = [
    {
      "order_number": "18588066",
      "accountnum": "ZCI0000",
      "shiptoaccount": "JCI3209",
      "salesperson": "265",
      "salespname": "TREY MCCLELLAN",
      "customerpo": "407721",
      "shipwarehouse": "02",
      "salesbranch": "02",
      "orderdate": "2024-07-23",
      "shippeddate": null,
      "requesteddate": "2024-07-23",
      "invoicedate": null,
      "payterm": "SUTHERLAND",
      "shipvia": "OUR TRUCK",
      "orderstatus": "H",
      "orderstatusdescription": "On Hold",
      "ordertotal": "3171.00",
      "freight": "0",
      "goodstotal": "3171.00",
      "tax": "0",
      "billtoname": "CIMARRON LUMBER & SUPPLY CO",
      "billtoaddr1": "ACCOUNTS PAYABLE",
      "billtoaddr2": "4000 MAIN ST",
      "billtocitystate": "KANSAS CITY, MO",
      "billtozip5": "64111",
      "shiptoname": "SUTHERLAND LBR #3209",
      "shiptoaddr1": "CHUCK ELLIS",
      "shiptoaddr2": "717 HIGHWAY 80 EAST",
      "shiptocitystate": "PEARL, MS",
      "shiptozip5": "39208",
      "lines": [
        {
          "ordernum": "18588066",
          "item_number": "SXMOBUCKS",
          "item_description": "Mo' Bucks Feed - 40 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "300",
          "unitprice": "10.57",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "BHM",
          "qtycancelled": "0",
          "qtymoved": "0"
        }
      ],
      "friendlyStatus": "On Hold"
    },
    {
      "order_number": "18589142",
      "accountnum": "ZCI0000",
      "shiptoaccount": "JCI3209",
      "salesperson": "265",
      "salespname": "TREY MCCLELLAN",
      "customerpo": "407890",
      "shipwarehouse": "02",
      "salesbranch": "02",
      "orderdate": "2024-07-23",
      "shippeddate": null,
      "requesteddate": "2024-08-15",
      "invoicedate": null,
      "payterm": "SUTHERLAND",
      "shipvia": "OUR TRUCK",
      "orderstatus": "F",
      "orderstatusdescription": "Future Order",
      "ordertotal": "6833.70",
      "freight": "0",
      "goodstotal": "6833.70",
      "tax": "0",
      "billtoname": "CIMARRON LUMBER & SUPPLY CO",
      "billtoaddr1": "ACCOUNTS PAYABLE",
      "billtoaddr2": "4000 MAIN ST",
      "billtocitystate": "KANSAS CITY, MO",
      "billtozip5": "64111",
      "shiptoname": "SUTHERLAND LBR #3209",
      "shiptoaddr1": "CHUCK ELLIS",
      "shiptoaddr2": "717 HIGHWAY 80 EAST",
      "shiptocitystate": "PEARL, MS",
      "shiptozip5": "39208",
      "lines": [
        {
          "ordernum": "18589142",
          "item_number": "RI70",
          "item_description": "General Purpose 13-13-13 Fertilizer - 50 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "200",
          "unitprice": "14.20",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "BO3",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18589142",
          "item_number": "RI65",
          "item_description": "Food Plot Fertilizer 15-5-5 - 40 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "200",
          "unitprice": "10.25",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "SHE4",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18589142",
          "item_number": "RI45",
          "item_description": "General Purpose 8-8-8 Fertilizer - 50 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "40",
          "unitprice": "11.53",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "BO3",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18589142",
          "item_number": "RI88X",
          "item_description": "Nitrogen 33-0-0 Fertilizer - 50 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "80",
          "unitprice": "14.20",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "AM0",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18589142",
          "item_number": "AP02M",
          "item_description": "Hi Calcium Lime Fairway - 40 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "66",
          "unitprice": "5.25",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "PEL1",
          "qtycancelled": "0",
          "qtymoved": "0"
        }
      ],
      "friendlyStatus": "Future Order"
    },
    {
      "order_number": "18589143",
      "accountnum": "ZCI0000",
      "shiptoaccount": "JCI3209",
      "salesperson": "265",
      "salespname": "TREY MCCLELLAN",
      "customerpo": "407899",
      "shipwarehouse": "02",
      "salesbranch": "02",
      "orderdate": "2024-07-23",
      "shippeddate": null,
      "requesteddate": "2024-07-23",
      "invoicedate": null,
      "payterm": "SUTHERLAND",
      "shipvia": "OUR TRUCK",
      "orderstatus": "H",
      "orderstatusdescription": "On Hold",
      "ordertotal": "4400.50",
      "freight": "0",
      "goodstotal": "4400.50",
      "tax": "0",
      "billtoname": "CIMARRON LUMBER & SUPPLY CO",
      "billtoaddr1": "ACCOUNTS PAYABLE",
      "billtoaddr2": "4000 MAIN ST",
      "billtocitystate": "KANSAS CITY, MO",
      "billtozip5": "64111",
      "shiptoname": "SUTHERLAND LBR #3209",
      "shiptoaddr1": "CHUCK ELLIS",
      "shiptoaddr2": "717 HIGHWAY 80 EAST",
      "shiptocitystate": "PEARL, MS",
      "shiptozip5": "39208",
      "lines": [
        {
          "ordernum": "18589143",
          "item_number": "SXRICE",
          "item_description": "Feed Rice Bran - 50 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "80",
          "unitprice": "9.40",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "KWC1",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18589143",
          "item_number": "SXRICEPB",
          "item_description": "Peanut Rice Bran - 50 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "80",
          "unitprice": "11.25",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "KWC1",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18589143",
          "item_number": "SXRICEPERSIM",
          "item_description": "Persimmon Rice Bran - 50 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "80",
          "unitprice": "11.95",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "KWC1",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18589143",
          "item_number": "SXKANDY",
          "item_description": "Acorn Bran Kandy Krunch - 40 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "50",
          "unitprice": "11.95",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "DBS",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18589143",
          "item_number": "SXSTRAWBERRY",
          "item_description": "Deer Jam Strawberry Blast - 40 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "50",
          "unitprice": "11.95",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "DBS",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18589143",
          "item_number": "SXPEANUTGRUB",
          "item_description": "Peanut Grub - 40 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "50",
          "unitprice": "11.95",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "DBS",
          "qtycancelled": "0",
          "qtymoved": "0"
        }
      ],
      "friendlyStatus": "On Hold"
    },
    {
      "order_number": "18589146",
      "accountnum": "ZCI0000",
      "shiptoaccount": "JCI3209",
      "salesperson": "265",
      "salespname": "TREY MCCLELLAN",
      "customerpo": "407889",
      "shipwarehouse": "02",
      "salesbranch": "02",
      "orderdate": "2024-07-23",
      "shippeddate": null,
      "requesteddate": "2024-07-23",
      "invoicedate": null,
      "payterm": "SUTHERLAND",
      "shipvia": "OUR TRUCK",
      "orderstatus": "R",
      "orderstatusdescription": "in Progress",
      "ordertotal": "2705.00",
      "freight": "0",
      "goodstotal": "2705.00",
      "tax": "0",
      "billtoname": "CIMARRON LUMBER & SUPPLY CO",
      "billtoaddr1": "ACCOUNTS PAYABLE",
      "billtoaddr2": "4000 MAIN ST",
      "billtocitystate": "KANSAS CITY, MO",
      "billtozip5": "64111",
      "shiptoname": "SUTHERLAND LBR #3209",
      "shiptoaddr1": "CHUCK ELLIS",
      "shiptoaddr2": "717 HIGHWAY 80 EAST",
      "shiptocitystate": "PEARL, MS",
      "shiptozip5": "39208",
      "lines": [
        {
          "ordernum": "18589146",
          "item_number": "SXAH225XDE",
          "item_description":
              "American Hunter XDE-Pro Feeder with Hopper - 225 lb",
          "uom": "EA",
          "uom_desc": "EACH",
          "quantity": "20",
          "unitprice": "92.00",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "GSM",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18589146",
          "item_number": "SXIWC04",
          "item_description": "Imperial Whitetail Clover - 4 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "20",
          "unitprice": "28.25",
          "ups_enabled": "Y",
          "pack_size": "Pk/1",
          "vendor": "WI4",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18589146",
          "item_number": "SXIWNP5",
          "item_description":
              "Imperial Whitetail No-Plow Food Plot Seed - 5 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "20",
          "unitprice": "15.00",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "WI4",
          "qtycancelled": "0",
          "qtymoved": "0"
        }
      ],
      "friendlyStatus": "In Progress"
    },
    {
      "order_number": "18587069",
      "accountnum": "ZCI0000",
      "shiptoaccount": "JCI3209",
      "salesperson": "265",
      "salespname": "TREY MCCLELLAN",
      "customerpo": "B",
      "shipwarehouse": "02",
      "salesbranch": "02",
      "orderdate": "2024-07-23",
      "shippeddate": null,
      "requesteddate": "2024-07-23",
      "invoicedate": null,
      "payterm": "SUTHERLAND",
      "shipvia": "OUR TRUCK",
      "orderstatus": "H",
      "orderstatusdescription": "On Hold",
      "ordertotal": "12.76",
      "freight": "0",
      "goodstotal": "12.76",
      "tax": "0",
      "billtoname": "CIMARRON LUMBER & SUPPLY CO",
      "billtoaddr1": "ACCOUNTS PAYABLE",
      "billtoaddr2": "4000 MAIN ST",
      "billtocitystate": "KANSAS CITY, MO",
      "billtozip5": "64111",
      "shiptoname": "SUTHERLAND LBR #3209",
      "shiptoaddr1": "CHUCK ELLIS",
      "shiptoaddr2": "717 HIGHWAY 80 EAST",
      "shiptocitystate": "PEARL, MS",
      "shiptozip5": "39208",
      "lines": [
        {
          "ordernum": "18587069",
          "item_number": "SXANTLERRAGE",
          "item_description": "Antler Rage Corn and Roasted Soybeans - 40 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "1",
          "unitprice": "12.76",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "DBS",
          "qtycancelled": "0",
          "qtymoved": "0"
        }
      ],
      "friendlyStatus": "On Hold"
    },
    {
      "order_number": "18589145",
      "accountnum": "ZCI0000",
      "shiptoaccount": "JCI3209",
      "salesperson": "265",
      "salespname": "TREY MCCLELLAN",
      "customerpo": "407891",
      "shipwarehouse": "02",
      "salesbranch": "02",
      "orderdate": "2024-07-23",
      "shippeddate": null,
      "requesteddate": "2024-07-23",
      "invoicedate": null,
      "payterm": "SUTHERLAND",
      "shipvia": "OUR TRUCK",
      "orderstatus": "R",
      "orderstatusdescription": "in Progress",
      "ordertotal": "743.20",
      "freight": "0",
      "goodstotal": "743.20",
      "tax": "0",
      "billtoname": "CIMARRON LUMBER & SUPPLY CO",
      "billtoaddr1": "ACCOUNTS PAYABLE",
      "billtoaddr2": "4000 MAIN ST",
      "billtocitystate": "KANSAS CITY, MO",
      "billtozip5": "64111",
      "shiptoname": "SUTHERLAND LBR #3209",
      "shiptoaddr1": "CHUCK ELLIS",
      "shiptoaddr2": "717 HIGHWAY 80 EAST",
      "shiptocitystate": "PEARL, MS",
      "shiptozip5": "39208",
      "lines": [
        {
          "ordernum": "18589145",
          "item_number": "SXBBLOCK",
          "item_description": "Whitetail Deer Block - 25 lb",
          "uom": "EA",
          "uom_desc": "EACH",
          "quantity": "80",
          "unitprice": "9.29",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "SX3",
          "qtycancelled": "0",
          "qtymoved": "0"
        }
      ],
      "friendlyStatus": "In Progress"
    },
    {
      "order_number": "18586491",
      "accountnum": "ZCI0000",
      "shiptoaccount": "GCI1904",
      "salesperson": "G37",
      "salespname": "MATTHEW MCKINNEY",
      "customerpo": "407473",
      "shipwarehouse": "10",
      "salesbranch": "10",
      "orderdate": "2024-07-22",
      "shippeddate": null,
      "requesteddate": "2024-07-22",
      "invoicedate": null,
      "payterm": "SUTHERLAND",
      "shipvia": "OUR TRUCK",
      "orderstatus": "R",
      "orderstatusdescription": "in Progress",
      "ordertotal": "330.80",
      "freight": "0",
      "goodstotal": "330.80",
      "tax": "0",
      "billtoname": "CIMARRON LUMBER & SUPPLY CO",
      "billtoaddr1": "ACCOUNTS PAYABLE",
      "billtoaddr2": "4000 MAIN ST",
      "billtocitystate": "KANSAS CITY, MO",
      "billtozip5": "64111",
      "shiptoname": "SUTHERLAND LBR #1904",
      "shiptoaddr1": "",
      "shiptoaddr2": "9503 E 21ST ST",
      "shiptocitystate": "TULSA, OK",
      "shiptozip5": "74129",
      "lines": [
        {
          "ordernum": "18586491",
          "item_number": "MS5375304",
          "item_description":
              "Roundup Weed & Grass Killer Pump 'N Go II - 1.33 gal",
          "uom": "EA",
          "uom_desc": "EACH",
          "quantity": "8",
          "unitprice": "28.46",
          "ups_enabled": "Y",
          "pack_size": "Pk/4",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586491",
          "item_number": "MS5377504",
          "item_description":
              "Roundup Dual Action Weed and Grass Killer - 1.33 Gal",
          "uom": "EA",
          "uom_desc": "EACH",
          "quantity": "4",
          "unitprice": "25.78",
          "ups_enabled": "N",
          "pack_size": "Pk/4",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        }
      ],
      "friendlyStatus": "In Progress"
    },
    {
      "order_number": "18585599",
      "accountnum": "ZCI0000",
      "shiptoaccount": "TCI3119",
      "salesperson": "123",
      "salespname": "JEFF FOX",
      "customerpo": "407448",
      "shipwarehouse": "01",
      "salesbranch": "01",
      "orderdate": "2024-07-22",
      "shippeddate": null,
      "requesteddate": "2024-07-22",
      "invoicedate": null,
      "payterm": "SUTHERLAND",
      "shipvia": "OUR TRUCK",
      "orderstatus": "R",
      "orderstatusdescription": "in Progress",
      "ordertotal": "534.58",
      "freight": "0",
      "goodstotal": "534.58",
      "tax": "0",
      "billtoname": "CIMARRON LUMBER & SUPPLY CO",
      "billtoaddr1": "ACCOUNTS PAYABLE",
      "billtoaddr2": "4000 MAIN ST",
      "billtocitystate": "KANSAS CITY, MO",
      "billtozip5": "64111",
      "shiptoname": "SUTHERLAND LBR #3119",
      "shiptoaddr1": "",
      "shiptoaddr2": "4545 COLLEGE",
      "shiptocitystate": "BEAUMONT, TX",
      "shiptozip5": "77707",
      "lines": [
        {
          "ordernum": "18585599",
          "item_number": "BD36808",
          "item_description": "Wild Delight Gourmet Outdoor Bird Food - 8 lb",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "41.12",
          "ups_enabled": "N",
          "pack_size": "Pk/4",
          "vendor": "DD5",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18585599",
          "item_number": "FE10027",
          "item_description": "Fertilome Tomato & Pepper Set RTU - 1 qt",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "68.49",
          "ups_enabled": "Y",
          "pack_size": "Pk/12",
          "vendor": "FE",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18585599",
          "item_number": "SD100504295",
          "item_description": "Just One Bite II Bars - 8 x 1 lb",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "139.40",
          "ups_enabled": "Y",
          "pack_size": "Pk/4",
          "vendor": "SD2B",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18585599",
          "item_number": "MT6002",
          "item_description":
              "Martin's Eraser Weed & Grass Killer Concentrate - 1 qt",
          "uom": "EA",
          "uom_desc": "EACH",
          "quantity": "6",
          "unitprice": "13.00",
          "ups_enabled": "Y",
          "pack_size": "Pk/6",
          "vendor": "PRO1",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18585599",
          "item_number": "BP941",
          "item_description": "Systemic Insect Control Concentrate - 1 pt",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "137.85",
          "ups_enabled": "Y",
          "pack_size": "Pk/12",
          "vendor": "BO4",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18585599",
          "item_number": "FE16011",
          "item_description": "Caterpillar Killer with Bt - 8 oz",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "69.72",
          "ups_enabled": "Y",
          "pack_size": "Pk/12",
          "vendor": "FE",
          "qtycancelled": "0",
          "qtymoved": "0"
        }
      ],
      "friendlyStatus": "In Progress"
    },
    {
      "order_number": "18586724",
      "accountnum": "ZCI0000",
      "shiptoaccount": "TCI2705",
      "salesperson": "160",
      "salespname": "SHERMAN SMITH",
      "customerpo": "407281",
      "shipwarehouse": "01",
      "salesbranch": "01",
      "orderdate": "2024-07-22",
      "shippeddate": null,
      "requesteddate": "2024-07-23",
      "invoicedate": null,
      "payterm": "SUTHERLAND",
      "shipvia": "OUR TRUCK",
      "orderstatus": "R",
      "orderstatusdescription": "in Progress",
      "ordertotal": "4355.77",
      "freight": "0",
      "goodstotal": "4355.77",
      "tax": "0",
      "billtoname": "CIMARRON LUMBER & SUPPLY CO",
      "billtoaddr1": "ACCOUNTS PAYABLE",
      "billtoaddr2": "4000 MAIN ST",
      "billtocitystate": "KANSAS CITY, MO",
      "billtozip5": "64111",
      "shiptoname": "SUTHERLAND LBR #2705",
      "shiptoaddr1": "",
      "shiptoaddr2": "1801 S. ZERO STREET",
      "shiptocitystate": "FORT SMITH, AR",
      "shiptozip5": "72901",
      "lines": [
        {
          "ordernum": "18586724",
          "item_number": "BHDEV3GALR",
          "item_description": "Utility Jug - 3 gal, Red",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "91.74",
          "ups_enabled": "N",
          "pack_size": "Pk/4",
          "vendor": "DE10",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "HDC15710",
          "item_description": "Poly Sprayer - 1 gal",
          "uom": "EA",
          "uom_desc": "EACH",
          "quantity": "40",
          "unitprice": "11.96",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "CHA9",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "HE620432",
          "item_description": "Milorganite 6-4-0 - 32 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "1",
          "unitprice": "11.21",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "MM",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "MR2345212",
          "item_description":
              "Osmocote Smart-Release Plant Food Plus Outdoor & Indoor - 1 lb",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "2",
          "unitprice": "67.32",
          "ups_enabled": "Y",
          "pack_size": "Pk/12",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "MR3039806",
          "item_description":
              "Miracle-Gro Water Soluble Azalea, Camellia, Rhododendron Plant Food - 5 lb",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "84.63",
          "ups_enabled": "Y",
          "pack_size": "Pk/6",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "MR74051430",
          "item_description": "Miracle-Gro Raised Bed & Garden Soil - 1 cf",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "60",
          "unitprice": "5.50",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "SI7",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "MS5375404",
          "item_description": "Roundup Weed & Grass Killer RTU Wand - 1 gal",
          "uom": "EA",
          "uom_desc": "EACH",
          "quantity": "8",
          "unitprice": "22.39",
          "ups_enabled": "Y",
          "pack_size": "Pk/4",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "MS5376712",
          "item_description":
              "Roundup Weed & Grass Killer Concentrate Plus - 16 oz",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "172.08",
          "ups_enabled": "Y",
          "pack_size": "Pk/12",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "NABTEX",
          "item_description": "100% Cotton Burr Compost - 2 cf",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "52",
          "unitprice": "8.47",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "BT4",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "MR75052430",
          "item_description": "Miracle-Gro Garden Soil All Purpose - 2 cf",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "39",
          "unitprice": "8.87",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "SI7",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "MR75586300",
          "item_description":
              "Miracle-Gro Moisture Control Potting Mix - 16 qt",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "91",
          "unitprice": "8.77",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "SI7",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "MR75651300",
          "item_description": "Miracle-Gro Potting Mix - 1 cf",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "80",
          "unitprice": "8.31",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "SI7",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "OR0220910",
          "item_description":
              "Ortho Home Defense Insect Killer for Indoor & Perimeter with Comfort Wand - 1.1 gal",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "2",
          "unitprice": "60.09",
          "ups_enabled": "N",
          "pack_size": "Pk/4",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "OR0448105",
          "item_description":
              "Ortho WeedClear Lawn Weed Killer North RTU Trigger - 1 gal",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "42.31",
          "ups_enabled": "N",
          "pack_size": "Pk/4",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "OR0448605",
          "item_description":
              "Ortho BugClear Insect Killer for Lawn & Landscape RTS - 32 oz",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "58.59",
          "ups_enabled": "N",
          "pack_size": "Pk/6",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "BY700270B",
          "item_description":
              "Complete Insect Killer for Soil & Turf Concentrate - 40 oz",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "94.00",
          "ups_enabled": "Y",
          "pack_size": "Pk/8",
          "vendor": "BP3",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "MT5201",
          "item_description": "Martin's I.G. Regulator - 1 oz",
          "uom": "EA",
          "uom_desc": "EACH",
          "quantity": "12",
          "unitprice": "6.09",
          "ups_enabled": "Y",
          "pack_size": "Pk/12",
          "vendor": "PRO1",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "FH32144",
          "item_description": "Hi-Yield Blood Meal 12-0-0 - 2.75 lb",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "56.34",
          "ups_enabled": "N",
          "pack_size": "Pk/12",
          "vendor": "FE",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "FX590016",
          "item_description": "Happy Frog Potting Soil - 12 qt",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "10",
          "unitprice": "6.96",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "FSF",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "FX690044",
          "item_description": "Ocean Forest Potting Soil  - 3 cf",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "1",
          "unitprice": "29.49",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "FSF",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "FX790096",
          "item_description": "Light Warrior Seed Starter - 1 cf",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "1",
          "unitprice": "18.27",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "FSF",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "NL242040",
          "item_description": "Next Level Hi-Energy 24-20 (Red Bag) - 40 lb",
          "uom": "EA",
          "uom_desc": "EACH",
          "quantity": "1",
          "unitprice": "39.59",
          "ups_enabled": "Y",
          "pack_size": "Pk/1",
          "vendor": "USPF",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586724",
          "item_number": "OR0275612",
          "item_description":
              "Ortho Home Defense MAX Ant, Roach & Spider Killer Aerosol - 18 oz",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "23.26",
          "ups_enabled": "N",
          "pack_size": "Pk/8",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        }
      ],
      "friendlyStatus": "In Progress"
    },
    {
      "order_number": "18586249",
      "accountnum": "ZCI0000",
      "shiptoaccount": "GCI3216",
      "salesperson": "G37",
      "salespname": "MATTHEW MCKINNEY",
      "customerpo": "407438",
      "shipwarehouse": "10",
      "salesbranch": "10",
      "orderdate": "2024-07-22",
      "shippeddate": null,
      "requesteddate": "2024-07-22",
      "invoicedate": null,
      "payterm": "SUTHERLAND",
      "shipvia": "OUR TRUCK",
      "orderstatus": "R",
      "orderstatusdescription": "in Progress",
      "ordertotal": "860.05",
      "freight": "0",
      "goodstotal": "860.05",
      "tax": "0",
      "billtoname": "CIMARRON LUMBER & SUPPLY CO",
      "billtoaddr1": "ACCOUNTS PAYABLE",
      "billtoaddr2": "4000 MAIN ST",
      "billtocitystate": "KANSAS CITY, MO",
      "billtozip5": "64111",
      "shiptoname": "SUTHERLAND LBR #3216",
      "shiptoaddr1": "",
      "shiptoaddr2": "15050 S MEMORIAL DR",
      "shiptocitystate": "BIXBY, OK",
      "shiptozip5": "74008",
      "lines": [
        {
          "ordernum": "18586249",
          "item_number": "MS5324504",
          "item_description":
              "Roundup Dual Action Weed and Grass Killer - 1 gal",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "64.52",
          "ups_enabled": "Y",
          "pack_size": "Pk/4",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586249",
          "item_number": "MS5378304",
          "item_description":
              "Roundup Dual Action Weed and Grass Killer Sure Shot Wand- 1 Gal",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "103.32",
          "ups_enabled": "Y",
          "pack_size": "Pk/4",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586249",
          "item_number": "MR4851012",
          "item_description":
              "Miracle-Gro Tree & Shrub Fertilizer Spikes - 3 lb",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "89.07",
          "ups_enabled": "N",
          "pack_size": "Pk/12",
          "vendor": "OR",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586249",
          "item_number": "FSTU25",
          "item_description": "Five Star Turf Type Fescue - 25 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "2",
          "unitprice": "45.41",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "PI6",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586249",
          "item_number": "BD36808",
          "item_description": "Wild Delight Gourmet Outdoor Bird Food - 8 lb",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "2",
          "unitprice": "36.59",
          "ups_enabled": "N",
          "pack_size": "Pk/4",
          "vendor": "DD5",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586249",
          "item_number": "BD373050",
          "item_description": "Wild Delight Golden Finch Food - 5 lb",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "72.06",
          "ups_enabled": "Y",
          "pack_size": "Pk/6",
          "vendor": "DD5",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586249",
          "item_number": "LG7506",
          "item_description":
              "Little Giant Complete Plastic Poultry Fount - 1 gal",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "26.46",
          "ups_enabled": "N",
          "pack_size": "Pk/6",
          "vendor": "LG",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586249",
          "item_number": "BD04",
          "item_description": "Black Oil Sunflower Seed - 50 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "3",
          "unitprice": "16.49",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "SH1",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586249",
          "item_number": "BD021",
          "item_description": "Wild Bird Food - 20 lb",
          "uom": "BG",
          "uom_desc": "BAG",
          "quantity": "6",
          "unitprice": "9.13",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "SH1",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586249",
          "item_number": "LG9833",
          "item_description":
              "Little Giant Galvanized Double Wall Waterer - 3 gal",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "55.83",
          "ups_enabled": "Y",
          "pack_size": "Pk/2",
          "vendor": "LG",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586249",
          "item_number": "LGP8BLUE",
          "item_description": "Little Giant Plastic Bucket - 8 qt,  Blue",
          "uom": "EA",
          "uom_desc": "EACH",
          "quantity": "6",
          "unitprice": "4.05",
          "ups_enabled": "N",
          "pack_size": "Pk/1",
          "vendor": "LG",
          "qtycancelled": "0",
          "qtymoved": "0"
        },
        {
          "ordernum": "18586249",
          "item_number": "BP420",
          "item_description": "Fog Rx Propane Insect Fogger",
          "uom": "CS",
          "uom_desc": "CASE",
          "quantity": "1",
          "unitprice": "156.24",
          "ups_enabled": "Y",
          "pack_size": "Pk/3",
          "vendor": "BO4",
          "qtycancelled": "0",
          "qtymoved": "0"
        }
      ],
      "friendlyStatus": "In Progress"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final order = data[index];
          final orderNumber = order['order_number'];
          final lines = order['lines'] as List<dynamic>;

          return ExpansionTile(
            title: Text(
              'Order Number: $orderNumber',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true, // Prevent nested list view from expanding
                physics: NeverScrollableScrollPhysics(), // Disable scrolling
                itemCount: lines.length,
                itemBuilder: (context, lineIndex) {
                  final line = lines[lineIndex];
                  final itemName = line['item_description'];
                  final quantity = line['quantity'];
                  final unitPrice = line['unitprice'];

                  return Text(
                    '- $itemName (x$quantity) - \$($unitPrice)',
                    style: TextStyle(fontSize: 14),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
