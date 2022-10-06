/**
 * ZeldaLoot Classic Build Script
 * By: Chris Siena (Chris221)
 * Site: https://ChrisSiena.com/
 * 
 * This script was written for my ZeldaLoot Classic zip-file compiling.
 * Normally working on windows this isn't needed due to not adding extras
 * to the .zip file on creation. Mac unfortunately does not do that..
 * Apple decided to add stupid files like .DS_Store in every folder which
 * serves 0 purpose. They also add __MACOSX folders which seem to just be
 * metadata? either way normal zips are supported and should be the normal
 * 
 * So here we are...
 */
const JSZip = require('jszip');
const path = require('path');
const fs = require('fs');

//Setup for Zip
const zip = new JSZip()
const base = zip.folder("ZeldaLoot_Classic");
const rootDirectoryPath = path.join(__dirname, '');

//Addon Data
const version = fs.readFileSync("ZeldaLoot_Classic.toc").toString().match(/## Version: ([0-9.]+)/)[1];
const dir = 'build/';
const file_name = `ZeldaLoot_Classic_v${version}.zip`;

//For release
var release_data = {
  releases: [
    {
      name: "ZeldaLoot Classic",
      version: `v${version}`,
      filename: file_name,
      nolib: false,
      metadata: [
        {
          flavor: "classic",
          interface: parseInt(fs.readFileSync("ZeldaLoot_Classic-Vanilla.toc").toString().match(/## Interface: ([0-9]+)/)[1]),
        },
        {
          flavor: "bcc",
          interface: parseInt(fs.readFileSync("ZeldaLoot_Classic-TBC.toc").toString().match(/## Interface: ([0-9]+)/)[1]),
        },
        {
          flavor: "wrath",
          interface: parseInt(fs.readFileSync("ZeldaLoot_Classic-WOTLKC.toc").toString().match(/## Interface: ([0-9]+)/)[1]),
        },
        {
          flavor: "mainline",
          interface: parseInt(fs.readFileSync("ZeldaLoot_Classic.toc").toString().match(/## Interface: ([0-9]+)/)[1]),
        }
      ]
    }
  ],
};

//For Zip
const folderPaths = [
  'Locale',
  'Sounds/Sets/ALTTP',
  'Sounds/Sets/OOT',
  'Sounds/Sets/TP',
];

var removeList = [
  //Remove Random Files
  '[]',
  '.DS_Store',
  //Remove Git Files
  '.gitignore',
  '.github',
  '.git',
  //Remove Node Files
  'node_modules',
  'package-lock.json',
  'package.json',
  'build.js',
  //Remove Folders
  'Old Sounds',
  'Sounds',
  'Locale',
  'build',
];

//Script - Zip
new Promise(res => fs.readdir(rootDirectoryPath, (err, files) => {
  var list = [];

  if (err) {
    return console.error('Unable to scan directory: ' + err);
  }

  files.forEach((file) => {
    list.push(file);
  });

  res(list);
}))
  .then(list => list.filter(x => !removeList.includes(x)).filter(x => x))
  .then(list => {
    console.log('Found under root', list);

    list.forEach(f => {
      let data = fs.readFileSync(f);
      base.file(f, data);
    });
  })
  .then(async () => {
    await Promise.all(folderPaths.map(f_path =>
      new Promise(res => fs.readdir(rootDirectoryPath + '/' + f_path, (err, files) => {
        var list = [];

        if (err) {
          return console.error('Unable to scan directory: ' + err);
        } 

        files.forEach((file) => {
          list.push(file);
        });

        res(list);
      }))
      .then(list => list.filter(x => !removeList.includes(x)).filter(x => x))
      .then(list => {
        console.log('Found under', f_path, list);

        list.forEach(async f => {
          let data = await fs.readFileSync(rootDirectoryPath + '/' + f_path + '/' + f);
          await base.file(f_path + '/' + f, data, { createFolders: true });
        });
      })
    ))
  })
  .then(async () => {
    if (!fs.existsSync(dir)){
      fs.mkdirSync(dir);
    }

    await zip.generateNodeStream({ type: 'nodebuffer', streamFiles: true ,compression: "DEFLATE", compressionOptions: { level: 9 } })
      .pipe(fs.createWriteStream(dir + file_name))
      .on('finish', () => console.log(`${file_name} saved!`))

    await fs.writeFile(dir + 'release.json', JSON.stringify(release_data, null, 2), (err) => {
      if (err) return console.error(err);

      console.log('release.json saved!');
    });
  })
  .catch(err => console.error(err));