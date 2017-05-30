$(function() {
    var LIMIT = 140,
        contentEl = $('#micropost_content');

    contentEl.after('<div id="micropost_content_remaining"></div>');
    var remainingEl = $('#micropost_content_remaining');
    $('#micropost_content').keyup(function() {
        remainingEl.text((LIMIT - this.value.length) + ' characters remaining');
    });
});

