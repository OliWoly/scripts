// Oliwier Kulczycki
// Get the pdf url using the network tab in inspect element.
// paste on the first line of the scripts.
// paste script into the console tab.

const pdfUrl = 'YOUR_PDF_URL';
const filename = pdfUrl.substring(pdfUrl.lastIndexOf('/') + 1) || 'download.pdf';

fetch(pdfUrl)
  .then(response => response.blob())
  .then(blob => {
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    window.URL.revokeObjectURL(url);
    document.body.removeChild(a);
  })
  .catch(e => console.error('Download failed:', e));
