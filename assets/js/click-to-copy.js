let codeListings = document.querySelectorAll('.highlight > pre');

const copyCode = (codeSample) => {
    const fullText = codeSample.textContent.trim();
    navigator.clipboard.writeText(fullText.replaceAll('$ ', '') + '\n');
};

for (let index = 0; index < codeListings.length; index++) {
    const parentWrapper = codeListings[index].parentElement
    const plausibleClass = parentWrapper.dataset.plausible
    const codeSample = codeListings[index].querySelector('code');
    const copyButton = document.createElement('button');
    const buttonAttributes = {
        type: 'button',
        title: 'Copy to clipboard',
        'data-bs-toggle': 'tooltip',
        'data-bs-placement': 'top',
        'data-bs-container': 'body',
    };

    Object.keys(buttonAttributes).forEach((key) => {
        copyButton.setAttribute(key, buttonAttributes[key]);
    });

    copyButton.classList.add(
        'fas',
        'fa-copy',
        'btn',
        'btn-dark',
        'btn-sm',
        'td-click-to-copy'
    );

    if (plausibleClass) {
        copyButton.classList.add(`plausible-event-name=${plausibleClass}`);
    }

    const tooltip = new bootstrap.Tooltip(copyButton);

    copyButton.onclick = () => {
        copyCode(codeSample);
        copyButton.setAttribute('data-bs-original-title', 'Copied!');
        tooltip.show();
    };

    copyButton.onmouseout = () => {
        copyButton.setAttribute('data-bs-original-title', 'Copy to clipboard');
        tooltip.hide();
    };

    const buttonDiv = document.createElement('div');
    buttonDiv.classList.add('click-to-copy');
    buttonDiv.append(copyButton);
    codeListings[index].insertBefore(buttonDiv, codeSample);
}
