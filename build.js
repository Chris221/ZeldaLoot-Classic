const JSZip = require('jszip');
const path = require('path');
const fs = require('fs');

const version = require('./package.json').version;
const dir = 'build/';

const file_name = `ZeldaLoot_Classic_v${version}`;
const zip = new JSZip()
const base = zip.folder("ZeldaLoot_Classic");
const rootDirectoryPath = path.join(__dirname, '');


const bcc = fs.readFileSync("ZeldaLoot_Classic-TBC.toc").toString().match(/## Interface: ([0-9]+)/)[1];
const classic = fs.readFileSync("ZeldaLoot_Classic-Vanilla.toc").toString().match(/## Interface: ([0-9]+)/)[1];
const wrath = fs.readFileSync("ZeldaLoot_Classic-WOTLKC.toc").toString().match(/## Interface: ([0-9]+)/)[1];
const retail = fs.readFileSync("ZeldaLoot_Classic.toc").toString().match(/## Interface: ([0-9]+)/)[1];

const base_release = {
  nolib: false,
  metadata: [
    {
      flavor: "classic",
      interface: parseInt(classic),
    },
    {
      flavor: "bcc",
      interface: parseInt(bcc),
    },
    {
      flavor: "wrath",
      interface: parseInt(wrath),
    },
    {
      flavor: "mainline",
      interface: parseInt(retail),
    }
  ]
};

var release_data = {
  releases: [],
};

const zipnames = [
  '',
  '-bcc',
  '-wotlk',
  '-classic',
];

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

    await Promise.all(zipnames.map(name => {
      let n = file_name + name + '.zip';

      release_data.releases.push({ filename: n, ...base_release });

      return new Promise(res => 
        zip.generateNodeStream({ type: 'nodebuffer', streamFiles: true })
          .pipe(fs.createWriteStream(dir + n))
          .on('finish', () => {
            console.log(`${n} saved!`);
            res();
          })
      );
    }));

    fs.writeFile(dir + 'release.json', JSON.stringify(release_data, null, 2), (err) => {
      if (err) return console.error(err);

      console.log('release.json saved!');
    });
  })
  .catch(err => console.error(err));